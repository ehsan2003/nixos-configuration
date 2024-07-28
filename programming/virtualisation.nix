{ ... }: {
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings.registry-mirrors =
    [ "https://registry.docker.ir" ];
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  home-manager.users.ehsan = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
  users.users.ehsan.extraGroups = [ "libvirtd" ];

}
