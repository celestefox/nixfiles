{
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (pkgs) rclone;
in {
  environment.systemPackages = [rclone];
  system.fsPackages = [rclone];
}
