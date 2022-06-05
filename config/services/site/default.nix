{ config, lib, pkgs, ... }: {
  services.nginx.virtualHosts."focks.pw" = {
    root = pkgs.static-site;
    enableACME = true;
    forceSSL = true;
  };
  services.nginx.virtualHosts."foxgirl.tech" = {
    root = pkgs.static-site;
    enableACME = true;
    forceSSL = true;
  };
  /*security.acme.certs."focks.pw" = {
    group = "nginx";
    dnsProvider = "gandiv5";
    credentialsFile = config.secrets.files.acme_creds.path;
  };*/
}
