{ pkgs, ... }: {
  # Global programs
  home.packages = with pkgs; [
    yt-dlp
    spotify
    spotify-tui
  ];

  # mpv
  programs.mpv = {
    enable = true;
    # TODO: yt-dlp fix?
    scripts = with pkgs.mpvScripts; [
      mpris
      sponsorblock
      thumbnail
      youtube-quality
    ];
    config = {
      script-opts = "ytdl_hook-ytdl_path=yt-dlp";
    };
  };

  # feh
  programs.feh.enable = true;

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
