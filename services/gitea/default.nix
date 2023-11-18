{
  config,
  lib,
  pkgs,
  root,
  ...
}:
with lib; {
  age.secrets.gitea-smtp = {
    file = root + "/secrets/gitea-smtp.age";
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
      server = mkForce {
        #??? Why do I need to do this? I can only see the default values...
        PROTOCOL = "http";
        HTTP_ADDR = "127.0.0.1";
        DOMAIN = "git.foxgirl.tech";
        ROOT_URL = "https://git.foxgirl.tech";
        SSH_DOMAIN = "star.foxgirl.tech";
        SSH_PORT = 62954;
      };
      ui = {
        THEMES = "gitea,arc-green,plex,aquamarine,dark,dracula,hotline,organizr,space-gray,hotpink,onedark,overseerr,nord";
        DEFAULT_THEME = "overseerr";
      };
    };
  };

  # Customising... weh
  # Since all of custom isn't okay to clobber, this instead
  systemd.services.gitea.serviceConfig.ExecStartPre = let
    customDir = config.services.gitea.customDir;
  in
    lib.mapAttrsToList (name: path: "${pkgs.coreutils}/bin/ln -sfT ${path} ${customDir}/${name}") {
      templates = ./templates;
      #public = ./public;
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
