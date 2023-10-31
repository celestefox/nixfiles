{
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (pkgs) rclone;
  rclone-mount = pkgs.symlinkJoin {
    name = "rclone-mount";
    paths = [rclone];
    postBuild = ''
      ln -s $out/bin/rclone $out/bin/mount.rclone
    '';
  };
in {
  environment.systemPackages = [rclone-mount];
  system.fsPackages = [rclone-mount];
}
