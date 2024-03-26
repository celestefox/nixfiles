{
  config,
  root,
  ...
}: let
  cfg = config.services.hedgedoc;
in {
  services.hedgedoc = {
    enable = true;
    settings = {
      domain = "md.foxgirl.tech";
      db = {
        dialect = "postgres";
        host = "/run/postgresql";
        username = "hedgedoc";
        database = "hedgedoc";
      };
      host = "127.0.0.1";
      port = 3030; # 3000 in use by gitea
      protocolUseSSL = true;
      urlAddPort = false;
      email = false; # "email" sign in
      allowAnonymous = false;
      allowAnonymousEdits = true; # allows for selecting "freely" permission for anon edits even w/ ^
      oauth2 = {
        baseURL = "https://auth.foxgirl.tech";
        userProfileURL = "https://auth.foxgirl.tech/realms/foxgirl/protocol/openid-connect/userinfo";
        userProfileUsernameAttr = "preferred_username";
        userProfileDisplayNameAttr = "name";
        userProfileEmailAttr = "email";
        userProfileIDAttr = "id";
        tokenURL = "https://auth.foxgirl.tech/realms/foxgirl/protocol/openid-connect/token";
        authorizationURL = "https://auth.foxgirl.tech/realms/foxgirl/protocol/openid-connect/auth";
        clientID = "hedgedoc";
        providerName = "foxgirl auth";
        scope = "openid email profile";
      };
    };
    environmentFile = config.age.secrets.hedgedoc_secret.path;
  };

  # keycloak client secret
  age.secrets.hedgedoc_secret.file = root + "/secrets/hedgedoc_secret.age";

  # https://docs.hedgedoc.org/configuration/#oauth2-login - the info box at the bottom of this section
  # honestly not sure if it's a problem on nixos or not, and not until i have something like keycloak
  systemd.services.hedgedoc = let
    postgres = ["postgresql.service"];
  in {
    after = postgres;
    #bindsTo = postgres;
    serviceConfig.Environment = ["NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt"];
  };

  services.postgresql = {
    enable = true;
    # name not actually exposed from the module, but hardcoding the name is good enough for here
    ensureDatabases = ["hedgedoc"];
    ensureUsers = [
      {
        name = "hedgedoc";
        ensureDBOwnership = true;
      }
    ];
  };

  services.nginx.virtualHosts."md.foxgirl.tech" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.settings.port}";
        recommendedProxySettings = true;
      };
      "/socket.io/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.settings.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };
}
