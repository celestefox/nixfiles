{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.systemd.user) systemctlPath;
  inherit (config.services.konawall) konashow;
  # i originally attempted to use masking in these, in hopes it could keep it
  # disabled across switches, but i could tell it wouldn't work with a status,
  # the masking wasn't visible. i believe this is because: the unit in practice
  # is loaded from `~/.config/systemd/user/` for me, masking ended up in
  # `/run/user/1111/systemd/user/` (or `$XDG_RUNTIME_DIR/systemd/user/`); as per
  # systemctl(1) on the mask command you need to care about the unit search path
  # - the mask must come first; systemd.unit(5) shows that in the "User Unit
  # Search Path", the XDG_RUNTIME_DIR path is lower than even the /etc path
  # which is lower than ~/.config. Interestingly, noting a similar situation
  # with the system unit path that should make system masking useless too...
  # does masking not actually work on nixos, effectively?
  konaoff = pkgs.writeShellScriptBin "konaoff" ''
    ${systemctlPath} --user is-active konawall-rotation.timer || exit 1
    ${systemctlPath} --user stop konawall-rotation.timer
    ${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${config.stylix.image}
  '';
  konaon = pkgs.writeShellScriptBin "konaon" ''
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
