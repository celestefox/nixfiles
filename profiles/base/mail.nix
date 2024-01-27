{
  config,
  root,
  ...
}: {
  age.secrets.email_catfg = {
    file = root + "/secrets/email_catfg.age";
    # This is slightly insecure, but the password has to be visible to a user
    # account sending email... a custom group is probably too much effort for
    # this, while I have no other local users, and zed seems to run as root, so
    # it's only other services as other users... still, weh >.< (i'd point to
    # gitea, but that needs to be in a different format and that's easier to
    # implement w/ agenix as a second secret anyways, not that i had it working
    # last time i tried, so it's still disabled because it's not high priority
    # without other people using my gitea, so.)
    group = "wheel";
    mode = "0440";
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
      passwordeval = "cat ${config.age.secrets.email_catfg.path}";
      host = "smtp.fastmail.com";
      port = 465;
      tls = true;
      tls_starttls = false;
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
