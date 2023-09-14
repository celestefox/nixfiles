{
  config,
  pkgs,
  ...
}: {
  # Global programs
  home.packages = with pkgs; [
    playerctl
    spotify
    spotify-tui
    streamlink
    #ytmdesktop # never even worked for me...
    ytfzf
  ];

  # mpv
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
      sponsorblock
      uosc
      thumbfast
      quality-menu
    ];
    # goes to input.conf
    bindings = {
      "F" = "script-binding quality_menu/video_formats_toggle";
      "Alt+f" = "script-binding quality_menu/audio_formats_toggle";
      "space" = "cycle pause; script-binding uosc/flash-pause-indicator";
      "m" = "no-osd cycle mute; script-binding uosc/flash-volume";
      "9" = "no-osd add volume -2; script-binding uosc/flash-volume";
      "0" = "no-osd add volume 2; script-binding uosc/flash-volume";
      "right" = "seek 5";
      "left" = "seek -5";
      "shift+right" = "seek 30; script-binding uosc/flash-timeline";
      "shift+left" = "seek -30; script-binding uosc/flash-timeline";
    };
    config = {
      osc = false; # uosc
      osd-bar = false;
      border = false;
      volume = 60;
    };
    scriptOpts = {
      ytdl_hook = {
        try_ytdl_first = true; # try parsing urls with yt-dlp first
        ytdl_path = config.programs.yt-dlp.package + "/bin/yt-dlp";
      };
      uosc = {
        pause_indicator = "manual";
      };
    };
  };

  # yt-dlp
  programs.yt-dlp.enable = true;

  # streamlink (package is above)
  # TODO: generate this? module?
  # TODO: wrapper to get twitch auth secret? extract from ff profile myself? encrypt a secret? is it long-lived?
  # ...I'd say i could just use ragenix secrets, but I'd have to write a module
  xdg.configFile."streamlink/config".text = ''
    player=${config.programs.mpv.finalPackage}/bin/mpv
  '';
  xdg.configFile."streamlink/config.twitch".text = ''
    twitch-disable-ads
    twitch-low-latency
    hls-segment-stream-data
    player-args=--profile=low-latency --cache=yes --demuxer-max-back-bytes=500MiB
  '';

  # feh
  programs.feh.enable = true;

  # playerctld
  services.playerctld.enable = true;

  # mpris-proxy
  services.mpris-proxy.enable = true;

  # spotifyd
  ## disabled cuz i never truly used it cuz it never worked well enough
  /*
  programs.spotifyd = {
    enable = true;
    package = (pkgs.spotifyd.override {
      withPulseAudio = true;
      withMpris = true;
      withKeyring = true;
    });
    settings = {
      global = {
        username = "myst@focks.pw";
        use_keyring = true; # For password storage
        use_mpris = true; # Should allow multimedia keys to affect it?
        backend = "pulseaudio";
        device_name = "amaterasu";
        bitrate = 320;
        volume_normalization = true;
        device_type = "computer";
      };
    };
  };
  */
}
