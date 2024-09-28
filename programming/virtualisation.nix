{ ... }: {
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings.registry-mirrors =
    [ "https://registry.docker.ir" ];

}
