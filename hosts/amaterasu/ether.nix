{lib, ...}: {
  systemd.network = {
    enable = true;
    wait-online = {
      anyInterface = true;
      ignoredInterfaces = ["wgnet"];
    };
    networks = {
      "20-ether" = {
        matchConfig = {
          Driver = "ax88179_*";
          Type = "ether";
          Name = "!v*"; # why :c
        };
        DHCP = "no";
        address = ["10.255.254.11/24"];
        linkConfig.RequiredForOnline = "no";
        # routes = [
        #   {}
        # ];
      };
      # the version in nixpkgs is only enabled if useNetworkd, but I'm hybrid networking here
      "40-vboxnet0" = {
        matchConfig.Name = "vboxnet";
        linkConfig.RequiredForOnline = "no";
      };
      # fully controlled by scripts instead
      # TODO: this wouldn't actually work for some reason
      #"10-wgnet" = {
      #matchConfig.Name = "wgnet";
      #matchConfig.Type = "wireguard";
      #linkConfig.Unmanaged = "yes";
      #};
    };
  };
  services.resolved.enable = lib.mkForce false;
  networking.interfaces.enp43s0f3u4.useDHCP = false;
  networking.interfaces.wgnet.useDHCP = false;
}
