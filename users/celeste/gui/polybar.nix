{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      pulseSupport = true;
      iwSupport = true;
      githubSupport = true;
    };
    script = ''
      polybar left &
      polybar right &
      #polybar bottom-left &
    '';
    settings = let
      common_module = {
        # dashed format needed here because otherwise you need a deep merge not //
        format-foreground = "\${colors.fg}";
        format-background = "\${colors.bg}";
        label-padding = "1";
        #label-margin = "10px";
      };
      commonbar = {
        height = "16";
        background = "\${colors.trans}";
        foreground = "\${colors.fg}";
        #radius.bottom = "3";
        font = [
          "FiraCode Nerd Font:style=Regular:size=8;2"
          "EB Garamond:style=Regular"
        ];
        #override-redirect = true;
        modules = {
          left = "date cpu mem";
          center = "i3";
          right = "wlan file vol";
        };
      };
    in {
      # bars
      "bar/left" =
        commonbar
        // {
          monitor = "HDMI-A-0";
          tray = {
            position = "right";
            background = "\${colors.bg}";
            foreground = "\${colors.fg}";
            #padding = "2";
          };
        };
      "bar/right" =
        commonbar
        // {
          monitor = "DVI-D-0";
        };
      "bar/bottom-left" = recursiveUpdate commonbar {
        monitor = "HDMI-A-0";
        bottom = true;
        modules = {
          left = "window";
          center = "";
          right = "media";
        };
      };
      # colors
      "colors" = {
        bg = "#0d0d1b";
        fg = "#ccccce";
        trans = "#00000000";
        "color0" = "#282828";
        "color1" = "#ca1444";
        "color2" = "#789aba";
        "color3" = "#b3879f";
        "color4" = "#94469b";
        "color5" = "#cb6fa1";
        "color6" = "#fb6e93";
        "color7" = "#cf98c1";
        "color8" = "#98218e";
        "color9" = "#cb515d";
        "color10" = "#5a87b1";
        "color11" = "#9c61ab";
        "color12" = "#9a77b1";
        "color13" = "#f2a297";
        "color14" = "#f4436f";
        "color15" = "#ebdbb2";
      };
      # modules
      ## center
      "module/i3" = {
        type = "internal/i3";
        pin-workspaces = true;
        show-urgent = true;
        #strip-wsnumbers = true;
        format = {
          foreground = "\${colors.fg}";
          background = "\${colors.bg}";
        };
        label = {
          focused = {
            foreground = "\${colors.color4}";
          };
          urgent.foreground = "\${colors.color14}";
        };
      };
      ## left
      "module/date" =
        common_module
        // {
          type = "internal/date";
          #interval = 1;
          label = "%date% %time%";
          date = "%Y-%m-%d";
          date-alt = "%A, %d %b %Y";
          time = "%H:%M:%S";
        };
      "module/cpu" =
        common_module
        // {
          type = "internal/cpu";
        };
      "module/mem" =
        common_module
        // {
          type = "internal/memory";
        };
      ## right
      "module/wlan" =
        common_module
        // {
          type = "internal/network";
          interface.type = "wireless";
          #format.packetloss = "<label-connected> <animation-packetloss>";
          label.connected = {
            text = "%ifname%@%essid%~%signal% %local_ip%";
            background = "\${colors.bg}";
            padding = 1;
          };
          label.disconnected = {
            text = "%ifname%@{!!!}";
            foreground = "\${colors.color1}";
            background = "\${colors.bg}";
            padding = 1;
          };
        };
      "module/wg" =
        common_module
        // {
          type = "internal/network";
          interface = "wgnet";
          label.connected = "%ifname% %local_ip%";
          label.disconnected = "%ifname% DOWN";
          unknown-as-up = true;
        };
      "module/file" =
        common_module
        // {
          type = "internal/fs";
          mount = ["/"];
          format.mounted = {
            foreground = "\${colors.fg}";
            background = "\${colors.bg}";
            padding = 1;
          };
        };
      "module/vol" =
        common_module
        // {
          type = "internal/pulseaudio";
          label-volume = "󰕾 %percentage%%";
          label-volume-background = "\${colors.bg}";
          scroll = {
            up = "#vol.inc";
            down = "#vol.dec";
          };
          click = {
            # left menu?
            right = "${pkgs.pavucontrol}/bin/pavucontrol";
          };
        };
      "module/media" = recursiveUpdate common_module {
        type = "custom/script";
        exec = "${pkgs.playerctl}/bin/playerctl metadata --format '{{ playerName }}: {{ artist }} - {{ title }} {{ duration(position) }}|{{ duration(mpris:length) }}' --follow";
        tail = true;
        format-foreground = "\${colors.color6}";
        click.left = "${pkgs.playerctl}/bin/playerctl play-pause";
      };
      "module/window" = recursiveUpdate common_module {
        type = "internal/xwindow";
        format-foreground = "\${colors.color6}";
        label.empty.text = "";
        label.empty.foreground = "\${colors.color1}";
      };
      /*
               "module/round-left" = {
      type = "custom/text";
      content = "";
      content-foregound = commonbar.background;
      };
      */
    };
  };
}
