{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    blender
    meld
    parsec-bin
    nyxt
  ];
}
