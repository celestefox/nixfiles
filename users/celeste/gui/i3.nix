{ config, lib, pkgs, ... }:
let
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
  /*   kitti3 = pkgs.poetry2nix.mkPoetryApplication rec { # TODO: unfinished potential improvement
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
  kit = kitti3 + "/bin/kitti3"; */
in
{
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
      ];
      # default!
      defaultWorkspace = "workspace number 0:~";
      # Auto back and forth
      workspaceAutoBackAndForth = true;
      # no bars mew
      bars = lib.mkForce [ ];
      # But some i3 stuff still uses these font settings...
      fonts = {
        names = [ "FiraCode Nerd Font" ];
        size = 12.0;
      };
      # keybindings
      keybindings = lib.mkOptionDefault {
        # Running
        "${modifier}+r" = "exec ${rofi} -show run";
        "${modifier}+d" = ''exec --no-startup-id ${dunstify} -u critical -t 2000 "use win+r!"'';
        "${modifier}+c" = ''exec ${rofi} -show calc -modi calc -no-show-match -no-sort -calc-command "${xdotool} type --clearmodifiers '{result}'"'';
        # Modes
        "${modifier}+s" = "mode resize"; #For size instead
        "${modifier}+o" = "mode ss";
        "${modifier}+Print" = "mode ss";
        # Layout
        "${modifier}+l" = "layout toggle all"; #and thus l to cycle layouts
        # Switch workplace between screens
        "${modifier}+x" = "move workspace to output right";
        # TODO: workplace setup (workspaces are dynamic, so configured as keybinds!)
        "${modifier}+grave" = "workspace number 0:~"; # TODO: replace grave binds w/ quake terminal stuff?
        "${modifier}+Shift+grave" = "move container to workspace number 0:~";
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
      };
      # adtl simple mode(s)
      modes = lib.mkOptionDefault {
        ss = {
          # Mod4 link;  sel  win  mon  all
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
        #top = 24; # for bars, with override-redirect = true
      };
      # window stuff
      window = {
        border = 0;
        titlebar = false;
      };
      # Floating!
      floating.criteria = [
        { instance = "qjackctl"; }
        { title = "Steam - Update News"; }
      ];
    };
    extraConfig = ''
      # Fullscreen automatically some stuff (mostly games), floating above
      for_window [class="StardewModdingAPI"] fullscreen enable
    '';
  };
}
