{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [libnotify];
  services.dunst = {
    enable = true;
    settings = {
      global = {
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        dmenu = "${config.programs.rofi.finalPackage}/bin/rofi -dmenu -p dunst";
        enable_posix_regex = true;
        follow = "mouse";
        idle_threshold = "5m";
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
