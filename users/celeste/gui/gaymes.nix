{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  myWine = pkgs.wineWowPackages.full;
  mySteam = pkgs.steam.override {extraPkgs = pkgs': [pkgs'.openssl_1_1];};
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
      mySteam # steam the platform
      mySteam.run # (steam-run, good for foreign game binaries of all kinds)
      #lutris # some game manager i guess prolly
      eidolon
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
      dolphin-emu # gamecube/wii emulator
      yuzu
      ryujinx # switch emulators
      #factorio # this works if you manually add to the store, at least, but
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
      Ryujinx = {
        exec_name = false;
      };
    };
  };

  # desktop entry overrides
  xdg.desktopEntries = {
    "Ryujinx" = {
      # unfortunately, there's not an actual "override" system... and reading would be complicated...
      # so this is pretty much copied from the original, except the modified exec.
      name = "Ryujinx";
      exec = "env DOTNET_EnableAlternateStackCheck=1 MANGOHUD=1 gamemoderun Ryujinx %f";
      mimeType = ["application/x-nx-nca" "application/x-nx-nro" "application/x-nx-nso" "application/x-nx-nsp" "application/x-nx-xci"];
      icon = "Ryujinx";
      comment = "A Nintendo Switch emulator";
      genericName = "Nintendo Switch Emulator";
      categories = ["Game" "Emulator"];
      prefersNonDefaultGPU = true;
      settings = {
        Keywords = "Switch;Nintendo;Emulator";
        StartupWMClass = "Ryujinx";
      };
    };
    "stardew.smapi" = let
    in {
      name = "Stardew Valley (SMAPI)";
      genericName = "1.5.6/3.18.4";
      exec = ''kitty -d ${config.home.homeDirectory}/games/stardew/game bash -c "steam-run gamemoderun ${pkgs.rlwrap}/bin/rlwrap -a -r ./StardewModdingAPI ; read -r -p \"Press enter to exit.\""'';
      #path = config.home.homeDirectory + "/games/stardew/game";
      icon = mkIf (builtins.pathExists ./stardew.png) ./stardew.png; # https://www.deviantart.com/syhmac/art/Stardew-Valley-Honeycomb-Rainmeter-Icon-859476552
      # TODO: not actually included in repo, download yourself or
      categories = ["Game"];
    };
  };
}
