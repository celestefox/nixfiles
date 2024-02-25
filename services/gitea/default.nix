{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
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
      mailer = lib.mkIf (config.services.mail.sendmailSetuidWrapper != null) {
        ENABLED = true;
        FROM = "foxgirl git <gitea@git.foxgirl.tech>";
        PROTOCOL = "sendmail";
        SENDMAIL_PATH = config.security.wrapperDir + "/" + config.services.mail.sendmailSetuidWrapper.program;
        SENDMAIL_ARGS = "--";
      };
      ui = {
        THEMES = "gitea,arc-green,plex,aquamarine,dark,dracula,hotline,organizr,space-gray,hotpink,onedark,overseerr,nord";
        DEFAULT_THEME = "arc-green"; # unfortunately, various issues, especially on diffs
      };
      # log.LEVEL = "Trace";
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
