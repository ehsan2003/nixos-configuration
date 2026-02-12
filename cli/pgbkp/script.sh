set -e

# Function to extract components from PostgreSQL URI
parse_uri() {
    local uri=$1
    local user
    local password
    local host
    local port
    local dbname

    user=$(echo "$uri" | sed -E 's/^postgres(ql)?:\/\/([^:]+):.*/\2/')
    password=$(echo "$uri" | sed -E 's/^postgres(ql)?:\/\/[^:]+:([^@]+).*/\2/')
    host=$(echo "$uri" | sed -E 's/^postgres(ql)?:\/\/[^@]+@([^:]+).*/\2/')
    port=$(echo "$uri" | sed -E 's/.*:([0-9]+)\/.*/\1/')
    dbname=$(echo "$uri" | sed -E 's/.*\/([^?]+).*/\1/')
    
    echo "$user|$password|$host|$port|$dbname"
}

# Function to check if input is a PostgreSQL URI
is_uri() {
    local input=$1
    [[ $input =~ ^postgres(ql)?:\/\/ ]]
}

# Function to check if input is a backup file
is_backup_file() {
    local input=$1
    [[ -f $input ]] && file "$input" | grep -q "PostgreSQL custom database dump"
}

# Function to validate PostgreSQL URI
validate_uri() {
    local uri=$1
    if [[ ! $uri =~ ^postgres(ql)?:\/\/[^:]+:[^@]+@[^:]+:[0-9]+\/[^\/]+$ ]]; then
        echo "Error: Invalid PostgreSQL URI format"
        echo "Expected format: postgresql://user:password@host:port/dbname"
        exit 1
    fi
}

# Function to validate backup file
validate_backup_file() {
    local file=$1
    if [[ ! -f $file ]]; then
        echo "Error: Backup file '$file' does not exist"
        exit 1
    fi
    if ! file "$file" | grep -q "PostgreSQL custom database dump"; then
        echo "Error: File '$file' is not a valid PostgreSQL backup"
        exit 1
    fi
}

# Function to check if required tools are installed
check_requirements() {
    local tools=("pg_dump" "pg_restore" "psql")
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo "Error: Required tool '$tool' is not installed"
            exit 1
        fi
      done
}

# Function to backup a database
backup_database() {
    local uri=$1
    local dump_file=$2
    
    # Parse URI
    IFS='|' read -r user pass host port db <<< "$(parse_uri "$uri")"
    
    echo "Starting database backup..."
    echo "Source database: $db on $host:$port"
    
    # Dump the database
    echo "Creating backup..."
    PGPASSWORD=$pass pg_dump \
        -Fc \
        -v \
        --no-owner \
        --no-acl \
        -h "$host" \
        -p "$port" \
        -U "$user" \
        -d "$db" \
        -f "$dump_file"
    
    # Check if dump was successful
    if [ $? -ne 0 ]; then
        echo "Error: Database dump failed"
        rm -f "$dump_file"
        exit 1
    fi
    
    echo "Backup completed successfully!"
}

# Function to restore a database
restore_database() {
    local uri=$1
    local dump_file=$2
    
    # Parse URI
    IFS='|' read -r user pass host port db <<< "$(parse_uri "$uri")"
    
    echo "Starting database restore..."
    echo "Destination database: $db on $host:$port"
    
    # Drop existing connections
    echo "Dropping existing connections..."
    PGPASSWORD=$pass psql \
        -h "$host" \
        -p "$port" \
        -U "$user" \
        -d postgres \
        -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$db' AND pid <> pg_backend_pid();"
    
    # Drop and recreate the database
    echo "Recreating database..."
    PGPASSWORD=$pass psql \
        -h "$host" \
        -p "$port" \
        -U "$user" \
        -d postgres \
        -c "DROP DATABASE IF EXISTS \"$db\";"
    
    PGPASSWORD=$pass psql \
        -h "$host" \
        -p "$port" \
        -U "$user" \
        -d postgres \
        -c "CREATE DATABASE \"$db\";"
    
    # Restore the dump
    echo "Restoring backup..."
    PGPASSWORD=$pass pg_restore \
        -v \
        --no-owner \
        --no-acl \
        -h "$host" \
        -p "$port" \
        -U "$user" \
        -d "$db" \
        "$dump_file"
    
    echo "Restore completed successfully!"
}

# Function to perform the migration
migrate_database() {
    local source=$1
    local dest=$2
    local temp_dump_file
    temp_dump_file="/tmp/db_backup_$(date +%Y%m%d_%H%M%S).dump"
    local source_is_uri=false
    local dest_is_uri=false
    
    echo "Starting database migration..."
    
    # Determine source type
    if is_uri "$source"; then
        source_is_uri=true
        validate_uri "$source"
    else
        validate_backup_file "$source"
    fi
    
    # Determine destination type
    if is_uri "$dest"; then
        dest_is_uri=true
        validate_uri "$dest"
    else
        if [[ -e $dest ]]; then
            echo "Error: Destination file '$dest' already exists"
            exit 1
        fi
    fi
    
    # Handle different combinations
    if $source_is_uri && $dest_is_uri; then
        # URI to URI
        backup_database "$source" "$temp_dump_file"
        restore_database "$dest" "$temp_dump_file"
        rm -f "$temp_dump_file"
    elif $source_is_uri && ! $dest_is_uri; then
        # URI to file
        backup_database "$source" "$dest"
    elif ! $source_is_uri && $dest_is_uri; then
        # File to URI
        restore_database "$dest" "$source"
    else
        # File to file
        cp "$source" "$dest"
    fi
    
    echo "Migration completed successfully!"
}

# Main script
main () {
    # Check if correct number of arguments provided
    if [ "$#" -ne 2 ]; then
        echo "Usage: $0 <source> <destination>"
        echo "Where source and destination can be either:"
        echo "  - PostgreSQL URI (postgresql://user:pass@host:port/dbname)"
        echo "  - Backup file path (.dump)"
        echo ""
        echo "Examples:"
        echo "  $0 postgresql://user:pass@localhost:5432/sourcedb postgresql://user:pass@localhost:5432/destdb"
        echo "  $0 backup.dump postgresql://user:pass@localhost:5432/newdb"
        echo "  $0 postgresql://user:pass@localhost:5432/sourcedb backup.dump"
        echo "  $0 source.dump dest.dump"
        exit 1
    fi
    
    local source=$1
    local dest=$2
    
    # Check required tools
    check_requirements
    
    # Perform migration
    migrate_database "$source" "$dest"
}

# Execute main function with all script arguments
main "$@"
