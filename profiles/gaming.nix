{...}: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
        inhibit_screensaver = 0;
      };
    };
  };
  systemd.user.services.gamemoded.restartTriggers = ["/etc/gamemode.ini"]; # not sure if this truly works, but shrug
}
