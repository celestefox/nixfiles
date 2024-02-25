{
  osConfig,
  config,
  lib,
  ...
}: {
  accounts.email = {
    accounts = {
      "celeste" = {
        address = "celeste@foxgirl.tech";
        passwordCommand = lib.mkIf config.celeste.localmail "cat ${osConfig.age.secrets.email_catfg.path}";
        primary = true;
        flavor = "fastmail.com";
        realName = "Celeste";
        aliases = [];
        signature = {
          text = ''
            Celeste
            https://foxgirl.tech
            https://keyoxide.org/9a1721c44c2e015e15ef6dfbe642875c488f6874
          '';
          showSignature = "append";
        };
        gpg = {
          key = "0xE642875C488F6874";
        };
        msmtp.enable = true;
        mbsync = {
          enable = true;
          create = "maildir";
          extraConfig.channel.CopyArrivalDate = true;
        };
        neomutt = {
          enable = true;
          # extraConfig = "set use_envelope_from = yes";
        };
      };
    };
  };
}
