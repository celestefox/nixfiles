{
  config,
  root,
  ...
}: {
  age.secrets.smtp = {
    file = root + "/secrets/smtp.age";
    # ugh!!!!!!!!
    mode = "0444";
  };
  programs.msmtp = {
    enable = true;
    defaults = {
      aliases = "/etc/" + config.environment.etc."aliases".target;
      syslog = true;
    };
    accounts.default = {
      auth = "plain";
      user = "celeste@foxgirl.tech";
      passwordeval = "cat ${config.age.secrets.smtp.path}";
      host = "smtp.fastmail.com";
      port = 587;
      tls = true;
      tls_starttls = true;
      from = "%U@%H.foxgirl.tech";
      syslog = "LOG_MAIL";
    };
  };
  environment.etc."aliases" = {
    text = let
      host = config.networking.hostName;
    in ''
      root: root@${host}.foxgirl.tech
      celeste: celeste@${host}.foxgirl.tech
      default: postmaster@${host}.foxgirl.tech
    '';
    mode = "0644";
  };
}
