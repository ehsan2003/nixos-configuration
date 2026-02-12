{ stdenv
, postgresql
, file
, makeWrapper
, lib
}:

stdenv.mkDerivation {
  pname = "pgbkp";
  version = "1.0.0";

  src = ./script.sh;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/pgbkp
    wrapProgram $out/bin/pgbkp \
      --prefix PATH : ${postgresql}/bin \
      --prefix PATH : ${file}/bin
  '';

  meta = with lib; {
    description = "PostgreSQL database migration tool";
    platforms = platforms.unix;
    mainProgram = "pgbkp";
  };
}
