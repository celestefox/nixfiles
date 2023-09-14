{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    blender
    parsec-bin
  ];
}
