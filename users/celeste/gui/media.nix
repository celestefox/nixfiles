{
  config,
  pkgs,
  ...
}: {
  # Global programs
  home.packages = with pkgs; [
    playerctl
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
      "mbtn_right" = "cycle pause; script-binding uosc/flash-pause-indicator";
      "m" = "no-osd cycle mute; script-binding uosc/flash-volume";
      "9" = "no-osd add volume -2; script-binding uosc/flash-volume";
      "0" = "no-osd add volume 2; script-binding uosc/flash-volume";
      "right" = "seek 5";
      "left" = "seek -5";
      "shift+right" = "seek 30; script-binding uosc/flash-timeline";
      "shift+left" = "seek -30; script-binding uosc/flash-timeline";
    };
    config = {
      border = false;
      sub-auto = "fuzzy";
      osc = false; # uosc
      osd-bar = false;
      #slang = "eng,en,en-en,en-nP7-2PuUl7o,en-en-nP7-2PuUl7o";
      #volume = 70;
      volume-max = 200;
      # best video no larger than 1080p on smallest edge or smallest res - they should still get returned as low prio and picked up by quality-menu still tho hopefully?
      # mark as watched for youtube
      # extract cookies from firefox, mainly for mark-watched
      # pass subs to mpv that match regex "en.*", currently see ramble from earlier pass profile foxgirl.ytsubs below before I moved it all here instead
      # write subs, does not actually write to disk as mpv is getting the urls instead and handles them
      # and also the auto subs, as many youtube videos lack subs. note I do not automatically load subs in mpv with a slang setting.
      ytdl-raw-options = ''format-sort="res:1080",mark-watched=,cookies-from-browser=firefox,sub-lang="en.*",write-sub=,write-auto-sub='';
      # quality experiments
      # mainly based on https://wiki.archlinux.org/title/Mpv#High_quality_configurations
      vo = "gpu-next";
      profile = "gpu-hq";
      # the ewa_lanczossharp recommended combined w/ gpu-next warns to move to this scale-blur value instead
      scale = "ewa_lanczos";
      scale-blur = 0.981251;
      # the message is not actually changed to cscale in text, but applies here too
      cscale = "ewa_lanczos";
      cscale-blur = 0.981251;
      # this is the fancy video sync stuff now:
      video-sync = "display-resample";
      # try to interpolate, needs video-sync=display-*
      interpolation = true;
      # "smoothmotion"
      tscale = "oversample";
    };
    scriptOpts = {
      ytdl_hook = {
        try_ytdl_first = true; # tries ytdl first on links, and I'm probably watching a YT video anyways
        ytdl_path = config.programs.yt-dlp.package + "/bin/yt-dlp";
      };
      uosc = {
        pause_indicator = "manual";
      };
    };
    profiles = {
      "foxgirl.ytsubs" = {
        /*
        It seems like the "right" way to add on multiple options, and maybe
        even look into restoring, would be through multiple "append"s (or
        "remove"s for restoring). That's... not really something expressible in
        the current home-manager module, I'd have to append text to the mpv
        conf myself? However, I'm certainly already forcibly setting
        `ytdl-raw-options`, I have the value right there, so... I can just
        build it here, I guess?

        https://github.com/mpv-player/mpv/issues/11675 suggests yt-dlp's
        `sub-lang` option is a regex, but I don't want their actual suggested
        regex as it isn't right for all videos - i have at least one where the
        only english (auto) caption is only en, and investigating the video in
        the issue, their en-en, even if it has the right contents, is the one
        from the autocaptions list, too, not the actual original caption, which
        is `en-nP7-2PuUl7o`. So, tell yt-dlp to only get anything starting with
        en, maybe slang can order tracks usefully?

        I think that, while the options say "write", since `mpv` passes `-J`,
        it only also prints out the right urls as part of the, i think, JSON
        data? See https://github.com/mpv-player/mpv/blob/master/player/lua/ytdl_hook.lua#L724
        , `json.requested_subtitles`.

        I'm still not totally sure... this might be something I want as default settings,
        actually/eventually? :thinking:
        */
        # ytdl-raw-options = base_ytdl_opts + '',sub-lang="en.*",write-sub=,write-auto-sub='';
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
}
