{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.systemd.user) systemctlPath;
  inherit (config.services.konawall) konashow;
in {
  services.konawall = {
    enable = true;
    interval = "5m";
  };
  home.packages = lib.singleton konashow;
  xdg.desktopEntries = {
    "konarotate" = {
      name = "konawall rotate";
      exec = "${systemctlPath} --user --no-block restart konawall-rotation.service";
    };
    "konashow" = {
      name = "konawall show";
      exec = ''kitty --class kittyhere bash -c "konashow | less -+FS"'';
    };
  };
}
