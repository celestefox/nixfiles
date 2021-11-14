{ config, pkgs, lib, tf, ... }: with lib;

{
  kw.secrets = [ "vaultwarden-admin-token" ];

  secrets.files.vaultwarden-env = {
    text = ''
      ADMIN_TOKEN=${tf.variables.vaultwarden-admin-token.ref}
    '';

    owner = "vaultwarden";
    group = "vaultwarden";
  };

  services.postgresql = {
    ensureDatabases = [ "vaultwarden" ];
    ensureUsers = [{
      name = "vaultwarden";
      ensurePermissions = { "DATABASE vaultwarden" = "ALL PRIVILEGES"; };
    }];
  };

  # No need to rename users

  services.vaultwarden = {
    enable = true;
    environmentFile = config.secrets.files.vaultwarden-env.path;
    dbBackend = "postgresql";
    config = {
      rocketPort = 4000;
      websocketEnabled = true;
      signupsAllowed = false;
      domain = "https://vault.${config.network.dns.domain}";
      databaseUrl = "postgreqsl://vaultwaren@/vaultwarden";
    };
  };

  services.nginx.virtualHosts."vault.${config.network.dns.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/".proxyPass = "http://127.0.0.1:4000";
      "/notifications/hub".proxyPass = "http://127.0.0.1:3012";
      "/notifications/hub/negotiate".proxyPass = "http://127.0.0.1:4000";
    };
  };

  deploy.tf.dns.records.services_vaultwarden = {
    inherit (config.network.dns) zone;
    domain = "vault";
    cname = { inherit (config.network.addresses.public) target; };
  };
}
