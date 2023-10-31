{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [libnotify];
  services.dunst = {
    enable = true;
    settings = {
      global = {
        dmenu = "${config.programs.rofi.finalPackage}/bin/rofi -dmenu -p dunst";
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        font = "FiraCode Nerd Font 10";
        enable_posix_regex = true;
        follow = "mouse";
      };
      spotify = {
        appname = "Spotify";
        history_ignore = "yes";
      };
      ytmusic = {
        appname = "KDE Connect";
        summary = "YouTube Music";
        history_ignore = "yes";
      };
    };
  };
}
