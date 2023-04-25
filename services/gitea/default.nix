{ config, lib, pkgs, flake, ... }: with lib;
{
  age.secrets.gitea-smtp = {
    file = flake.outPath + "/secrets/gitea-smtp.age";
    owner = "gitea";
    group = "gitea";
  };

  services.postgresql = {
    enable = true;
  };

  services.gitea = {
    enable = true;
    appName = "foxgirl git";
    database = {
      type = "postgres";
      name = "gitea";
      user = "gitea";
    };
    mailerPasswordFile = config.age.secrets.gitea-smtp.path;
    settings = {
      service = {
        DISABLE_REGISTRATION = true;
        COOKIE_SECURE = true;
      };
      server = mkForce { #??? Why do I need to do this? I can only see the default values...
        PROTOCOL = "http";
        HTTP_ADDR = "127.0.0.1";
        DOMAIN = "git.foxgirl.tech";
        ROOT_URL = "https://git.foxgirl.tech";
        #SSH_USER = "git";
        SSH_DOMAIN = "foxgirl.tech"; # ...
        SSH_PORT = 62954;
      };
    };
  };

  services.nginx.virtualHosts."git.foxgirl.tech" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      # TODO: serve static separately?
      "/" = {
        proxyPass = "http://127.0.0.1:3000";
        recommendedProxySettings = true;
      };
    };
  };
}
