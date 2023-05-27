{ config, lib, pkgs, ... }: {
  home.packages = lib.singleton pkgs.rclone;
}
