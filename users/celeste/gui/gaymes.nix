{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  myWine = pkgs.wineWowPackages.full;
  #myBottles = pkgs.bottles.override { wineWowPackages = { minimal = myWine; }; };
  # didn't even get this to work
  #factorio_token = builtins.readFile ./FACTORIO_TOKEN;
  #myFactorio = pkgs.factorio.override {
  #  username = "celestefoxgirl";
  #  token = factorio_token;
  #};
in {
  home.packages = mkMerge [
    #(mkIf (builtins.pathExists ./FACTORIO_TOKEN) [ myFactorio ]) # can't get it to actually fetch still?
    (with pkgs; [
      steam # steam the platform
      steam.run # (steam-run, good for foreign game binaries of all kinds)
      #lutris # some game manager i guess prolly
      #wyvern # GOG games downloader/installer handler (broken build?)
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
      dolphin-emu # gamecube/wii emulator
      yuzu
      ryujinx # switch emulators
      factorio # this works if you manually add to the store, at least, but
    ])
  ];

  # MangoHud
  programs.mangohud = {
    enable = true;
    # https://github.com/flightlessmango/MangoHud/blob/master/data/MangoHud.conf
    settings = {
      #preset = 3;
      exec_name = true;
      gamemode = true;
    };
    settingsPerApplication = {
      mpv = {
        no_display = true;
      };
      java = {
        exec_name = false;
      };
    };
  };
}
