{ lib, pkgs, ... }: with lib; let
  pkgsUnstable = import <nixpkgs-unstable> { allowUnfree = true; };
in
{
  # General packages
  home.packages = with pkgs; [
    #discordUnstable
    discord-ptb
    tdesktop
    mumble
  ];
}
