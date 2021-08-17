{ config, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./sway.nix
    ./filesystems.nix
    ./xdg-portals.nix
    ./mingetty.nix
    ./sound.nix
  ];

  deploy.profile.gui = true;
}
