{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.xsession.windowManager.i3;
  modifier = cfg.config.modifier;
  rofi = config.programs.rofi.finalPackage + "/bin/rofi";
  dunstify = config.services.dunst.package + "/bin/dunstify";
  pactl = pkgs.pulseaudio + "/bin/pactl";
  playerctl = pkgs.playerctl + "/bin/playerctl";
  kitty = config.programs.kitty.package + "/bin/kitty";
  xdotool = pkgs.xdotool + "/bin/xdotool";
  shotgun = pkgs.shotgun + "/bin/shotgun";
  slop = pkgs.slop + "/bin/slop";
  ss = config.celeste.ss.package + "/bin/ss";
  dunstctl = config.services.dunst.package + "/bin/dunstctl";
  firefox = config.programs.firefox.package + "/bin/firefox";
  ssModeName = ''ss: + link  sel  win  mon  all'';
  /*
       kitti3 = pkgs.poetry2nix.mkPoetryApplication rec { # TODO: unfinished potential improvement
    pname = "kitti3";
    version = "0.4.1";

    projectDir = pkgs.fetchFromGitHub {
      owner = "LandingEllipse";
      repo = "kitti3";
      rev = "f9f94c8b9f8b61a9d085206ada470cfe755a2a92";
      sha256 = "bcIzbDpIe2GKS9EcVqpjwz0IG2ixNMn06OIQpZ7PeH0=";
    };

    meta = with lib; {
      homepage = "https://github.com/LandingEllipse/kitti3";
      description = "Kitty drop-down manager for i3 & Sway";
      license = licenses.bsd3;
    };
    };
  kit = kitti3 + "/bin/kitti3";
  */
in {
  xsession.windowManager.i3 = {
    enable = true;
    #package = pkgs.i3-gaps;
    config = {
      # Default modifier key
      modifier = "Mod4";
      # Terminal to use
      terminal = kitty;
      # startup
      startup = [
        #{ command = "${kit}"; always = true; notification = false; }
        # Vaguely based on the line from sway, because something with my config means that dbus isn't getting DISPLAY?
        # which manifested as... keychain prompter being unable to start, because it's launched through dbus, ig
        # i swear it had to have worked once... right? ...or maybe, only first run worked right, when no normal prompt was needed
        {
          command = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY";
          notification = false;
        }
      ];
      # default!
      defaultWorkspace = "workspace number 0:~";
      # Auto back and forth
      workspaceAutoBackAndForth = true;
      # no bars mew
      bars = lib.mkForce [];
      # keybindings
      keybindings = lib.mkOptionDefault {
        # Running
        "${modifier}+r" = "exec ${rofi} -show drun";
        "${modifier}+space" = "exec ${rofi} -show combi";
        "XF86Tools" = "exec ${rofi} -show drun";
        "XF86Search" = "exec ${rofi} -show drun";
        #"XF86HomePage" = ''exec --no-startup-id ${dunstify} -u critical -t 2000 "todo!"'';
        #"XF86WWW" = "exec ${firefox}";
        "${modifier}+d" = ''exec --no-startup-id ${dunstify} -u critical -t 2000 "use win+r!"'';
        "${modifier}+c" = ''exec ${rofi} -show calc -modi calc -no-show-match -no-sort -calc-command "${xdotool} type --clearmodifiers '{result}'"'';
        # Modes
        "${modifier}+s" = "mode resize"; #For size instead
        "${modifier}+o" = "mode ${ssModeName}";
        "${modifier}+Print" = "mode ${ssModeName}";
        # Layout
        "${modifier}+p" = "layout toggle all"; #oops, right, l is used
        "${modifier}+v" = "split v"; # vertical
        "${modifier}+b" = "split h"; # horizontal
        # and now movements
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";
        # Switch workplace between screens
        "${modifier}+x" = "move workspace to output right";
        # TODO: workplace setup (workspaces are dynamic, so configured as keybinds!)
        "${modifier}+grave" = "workspace number 0:~"; # TODO: replace grave binds w/ quake terminal stuff?
        "${modifier}+Shift+grave" = "move container to workspace number 0:~";
        "${modifier}+1" = "workspace number 1:www";
        "${modifier}+Shift+1" = "move container to workspace number 1:www";
        "${modifier}+minus" = "workspace number 11:-";
        "${modifier}+Shift+minus" = "move container to workspace number 11:-";
        "${modifier}+equal" = "workspace number 12:=";
        "${modifier}+Shift+equal" = "move container to workspace number 12:=";
        "${modifier}+BackSpace" = "workspace number 13:←";
        "${modifier}+Shift+BackSpace" = "move container to workspace 13:←";
        #"${modifier}+grave" = "nop kitti3"; # i guess turns out nops make convenient no-execute commands if you're a service listening to i3
        # Media keys
        "XF86AudioRaiseVolume" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec --no-startup-id ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioPlay" = "exec --no-startup-id ${playerctl} play-pause";
        "XF86AudioPrev" = "exec --no-startup-id ${playerctl} previous";
        "XF86AudioNext" = "exec --no-startup-id ${playerctl} next";
        # Notif stuff?
        "${modifier}+period" = "exec --no-startup-id ${dunstctl} context";
        "${modifier}+Shift+period" = "exec --no-startup-id ${dunstctl} history-pop";
        # scratchpad on \
        "${modifier}+Shift+backslash" = "move scratchpad";
        "${modifier}+backslash" = "scratchpad show";
      };
      # adtl simple mode(s)
      modes = lib.mkOptionDefault {
        ${ssModeName} = {
          # ss: + link;  sel  win  mon  all
          "Up" = "exec --no-startup-id ${ss} select copy; mode default";
          "Mod4+Up" = "exec --no-startup-id ${ss} select link; mode default";
          "Left" = "exec --no-startup-id ${ss} window copy; mode default";
          "Mod4+Left" = "exec --no-startup-id ${ss} window link; mode default";
          "Right" = "exec --no-startup-id ${ss} display copy; mode default";
          "Mod4+Right" = "exec --no-startup-id ${ss} display link; mode default";
          "Down" = "exec --no-startup-id ${ss} all copy; mode default";
          "Mod4+Down" = "exec --no-startup-id ${ss} all link; mode default";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };
      # Gaps settings
      gaps = {
        inner = 4;
        outer = 8;
        smartGaps = true;
        #smartBorders = "no_gaps";
        #top = 24; # for bars, with override-redirect = true
      };
      # window stuff
      window = {
        border = 0;
        titlebar = false;
      };
      # Floating!
      #floating.titlebar = true;
      floating.criteria = [
        {instance = "qjackctl";}
        {title = "Steam - Update News";}
        {
          class = "kittyhere";
        }
      ];
      # assigns
      assigns = {
        #"number 1:www" = [{class = "firefox";}]; # i only really want my main window, but there's not really a way to do that?
        "number 12:=" = [{class = "discord";} {class = "TelegramDesktop";}];
        "number 13:←" = [
          {
            instance = "status";
            class = "kitty";
          }
          {class = "Pavucontrol";}
          # apparently that's what it is for me
          # if this was dunst,
          {class = ".blueman-manager-wrapped";}
        ];
      };
    };
    extraConfig = ''
      # Fullscreen automatically some stuff (mostly games), floating above
      for_window [class="StardewModdingAPI"] fullscreen enable
    '';
  };
  home.packages = with pkgs; [i3-swallow];
}
