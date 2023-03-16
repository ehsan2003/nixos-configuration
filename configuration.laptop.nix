{pkgs , ...}:
{
  imports = [./common.nix];
  networking.hostName = "nixos-laptop"; # Define your hostname.

  boot.loader.grub.device="nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber=true;
  users.users.test = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        firefox
        thunderbird
        
      ];
  };
  home-manager.users.test =  {
      home.shellAliases = {
        v = "nvim";
      };
      home.stateVersion = "22.11";
      home.file.i3Config = import ./i3-config.nix {pkgs = pkgs;};
      home.file.astroNvim = {
        enable =  true; 
        source = (fetchGit {url ="https://github.com/AstroNvim/AstroNvim";}).outPath;
        target = ".config/nvim";
      };
      home.file.astroNvimConfig = {
        enable =  true; 
        text = builtins.readFile ./astronvim.init.lua;
        target = ".config/astronvim/lua/user/init.lua";
      };

      programs = {
        bash.enable = true ;      
        
        helix = {
          enable = true ;
          settings = {
            theme = "tokyonight" ;
          };
        };      
        
        rofi = {
          enable = true ;
          theme = "Adapta-Nokto" ;
        };
        alacritty = {
          enable = true; 
        };
        git = {
          enable = true ;
          userName = "ehsan" ;
          userEmail = "ehsan2003.2003.382@gmail.com";
        };
                   
      };
      
  };

  services.xserver.displayManager.sessionCommands = "sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 94 = Shift_L' &";
  home-manager.users.ehsan.programs.alacritty.settings.font.size=12;

}
