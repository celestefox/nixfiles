{ config, lib, pkgs, ... }: {
  services.nginx.virtualHosts."focks.pw" = {
    root = pkgs.static-site;
#    enableACME = true;
#    forceSSL = true;
  };
}
