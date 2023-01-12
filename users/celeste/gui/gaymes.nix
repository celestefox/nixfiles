{ config, lib, pkgs, ... }: with lib; let
  myWine = pkgs.wineWowPackages.full;
  #myBottles = pkgs.bottles.override { wineWowPackages = { minimal = myWine; }; };
in
{
  home.packages = with pkgs; [
    steam # steam the platform
    steam.run # (steam-run, good for foreign game binaries of all kinds)
    #lutris # some game manager i guess prolly
    wyvern # GOG games downloader/installer handler
    myWine #wine
    bottles # alternative wineprefix manager/incl own deps instead of winetricks
    winetricks # fancy wine stuff
    protontricks # winetricks for proton
    #minecraft # the normal launcher, ehh
    #polymc # multimc fork
    prismlauncher # PolyMC fork after takeover
    minetest # neat game
    ccemux # computercraft emulator
    #runelite # OSRS client, ehh
  ];
}
