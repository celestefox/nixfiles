{ config, ... }:

{
  imports = [
    ./xdg.nix
    ./fonts.nix
    ./foot.nix
    ./gtk.nix
    ./qt.nix
  ];
}
