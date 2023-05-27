{ config, pkgs, ... }: {
  # Global programs
  home.packages = with pkgs; [
    playerctl
    spotify
    spotify-tui
    streamlink
    ytmdesktop
    ytfzf
  ];

  # mpv
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
      sponsorblock
      thumbnail
      youtube-quality # unclear script error when I try to use the keybind
    ];
    config = {
      osc = false; # thumbnail script provides a patched osc
      volume = 60;
    };
    scriptOpts = {
      ytdl_hook = {
        try_ytdl_first = true; # try parsing urls with yt-dlp first
        ytdl_path = config.programs.yt-dlp.package + "/bin/yt-dlp";
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
