{
  config,
  lib,
  ...
}: {
  options = {
    celeste.localmail =
      lib.mkEnableOption "celeste localmail";
  };
  config = lib.mkIf config.celeste.localmail {
    programs.msmtp = {
      enable = true;
    };
    programs.mbsync = {
      enable = true;
    };
    programs.notmuch = {
      # enable = true;
    };
    programs.neomutt = {
      enable = true;
      sort = "reverse-threads";
      sidebar = {
        enable = true;
      };
      settings = {
        date_format = "%FT%T%z";
        fast_reply = "yes";
        reverse_name = "yes";
        include = "yes";
        mark_old = "no";
        wait_key = "no";
      };
    };
  };
}
