{ config, lib, pkgs, ... }: {
  services.nginx.virtualHosts."example.com" = {
    root = pkgs.static-site;
#    enableACME = true;
#    forceSSL = true;
  };
}
