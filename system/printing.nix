{ pkgs,... }: {
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint hplip splix ];
}
