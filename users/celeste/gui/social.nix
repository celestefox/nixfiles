{ lib, pkgs, ... }: with lib;
{
  # General packages
  home.packages = with pkgs; [
    #discordUnstable
    discord-ptb
    tdesktop
    mumble
  ];
}
