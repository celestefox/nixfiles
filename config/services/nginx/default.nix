{ config, lib, pkgs, ... }: with lib;

{
  network.firewall = {
    public.tcp.ports = [ 443 80 ];
    private.tcp.ports = [ 443 80 ];
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    # No certs right now!
    #recommendedTlsSettings = true;
    clientMaxBodySize = "512m";
  };

  # ACME?
}
