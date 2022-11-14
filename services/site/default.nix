{ config, lib, pkgs, ... }: {
  services.nginx.virtualHosts."foxgirl.tech" = {
    root = ./www;
    enableACME = true;
    forceSSL = true;
  };
    services.nginx.virtualHosts."focks.pw" = {
    root = ./www;
    enableACME = true;
    forceSSL = true;
  };
  /*security.acme.certs."focks.pw" = {
    group = "nginx";
    dnsProvider = "gandiv5";
    credentialsFile = config.secrets.files.acme_creds.path;
  };*/
}
