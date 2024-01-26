{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.systemd.user) systemctlPath;
  inherit (config.services.konawall) konashow;
  konaoff = pkgs.writeShellScriptBin "konaoff" ''
    ${systemctlPath} --user is-active konawall-rotation.timer || exit 1
    ${systemctlPath} --user stop konawall-rotation.timer
    ${systemctlPath} --user --runtime mask konawall-rotation.timer
    ${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${config.stylix.image}
  '';
  konaon = pkgs.writeShellScriptBin "konaon" ''
    if ${systemctlPath} --user is-enabled konawall-rotation.timer; then exit 1; fi
    ${systemctlPath} --user --runtime unmask konawall-rotation.timer
    ${systemctlPath} --user start konawall-rotation.timer
  '';
in {
  services.konawall = {
    enable = true;
    interval = "5m";
  };
  home.packages = [konashow konaoff konaon];
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
