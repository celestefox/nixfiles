{
  config,
  pkgs,
  root,
  ...
}: let
  cfg = config.services.keycloak;
in {
  services.keycloak = {
    enable = true;
    database = {
      type = "postgresql";
      passwordFile = config.age.secrets."keycloak_db_pw".path;
      createLocally = true;
    };
    settings = {
      hostname = "auth.foxgirl.tech";
      hostname-admin = "auth.wg.foxgirl.tech";
      http-host = "127.0.0.1";
      http-port = 3090;
      http-enabled = true;
      #proxy-headers = "xforwarded"; # oops, this is 24 and that's not the version here
      proxy = "edge";
    };
  };

  age.secrets."keycloak_db_pw" = {
    file = root + "/secrets/keycloak_db_pw.age";
    # readable in database setup script despite that being as postgres because
    # it uses LoadCredentials, which reads it as systemd and writes to another
    # place (again, but, hey, it works, unlike no password didn't. JDBC?)
    #group = "keycloak";
    #mode = "0440";
  };

  # keycloak wants you to set this (or disable XA), there isn't a bit in the
  # module for that, so this puts it in /run/keycloak/conf
  systemd.services.keycloak.serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/install -D -m 0600 ${pkgs.writeText "quarkus.properties" ''
    quarkus.transaction-manager.enable-recovery=true
  ''} /run/keycloak/conf/quarkus.properties";

  # systemd.services.keycloak = {
  #   after = ["postgresql.service"];
  #   bindsTo = ["postgresql.service"];
  # };

  # services.postgresql = {
  #   enable = true;
  #   ensureDatabases = ["keycloak"];
  #   ensureUsers = [
  #     {
  #       name = "keycloak";
  #       ensureDBOwnership = true;
  #     }
  #   ];
  # };

  services.nginx.virtualHosts."auth.foxgirl.tech" = {
    enableACME = true;
    forceSSL = true;
    serverAliases = ["auth.wg.foxgirl.tech"];
    acmeRoot = null;
    locations = let
      keycloakProxy = {
        proxyPass = "http://127.0.0.1:${toString cfg.settings.http-port}";
        recommendedProxySettings = true;
      };
    in {
      "/" =
        keycloakProxy
        // {
          extraConfig = ''
            allow 127.0.0.1;
            allow ::1;
            allow 10.255.255.0/24;
            allow 2a01:4f9:c010:2cf9:f::/80;
            deny all;
          '';
        };
      "= /" = {return = "302 https://auth.foxgirl.tech/realms/foxgirl/account";};
      "/js/" = keycloakProxy;
      "/realms/" = keycloakProxy;
      "/resources/" = keycloakProxy;
      "/robots.txt" = keycloakProxy;
    };
  };

  security.acme.certs."auth.foxgirl.tech" = {
    dnsProvider = "cloudflare";
    environmentFile = config.age.secrets.cf_lego.path;
  };
}
