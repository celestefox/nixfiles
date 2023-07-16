{lib, ...}: {
  systemd.network = {
    enable = true;
    networks."10-ether" = {
      matchConfig.Type = "ether";
      address = ["10.255.254.11/24"];
      linkConfig.RequiredForOnline = "no";
      # routes = [
      #   {}
      # ];
    };
  };
  services.resolved.enable = lib.mkForce false;
}
