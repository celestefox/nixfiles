{ config, lib, pkgs, ... }: with lib; {
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      #i3GapsSupport = true;
      pulseSupport = true;
      iwSupport = true;
      githubSupport = true;
    };
    script = ''
      polybar left &
      polybar right &
    '';
    settings = let
    common_module = {
      # dashed format needed here because otherwise you need a deep merge not //
      format-forground = "\${colors.fg}";
      format-background = "\${colors.bg}";
      label-padding = "1";
    };
    commonbar = {
      height = "20";
      background = "\${colors.trans}";
      foreground = "\${colors.fg}";
      radius.bottom = "3";
      font = [
        "EB Garamond:style=Regular"
        "FuraCode Nerd Font:style=Regular"
      ];
      modules = {
        left = "date cpu mem";
        center = "i3";
        right = "wlan wg file";
      };
    }; in
      {
        # bars
        "bar/left" = commonbar // {
          monitor = "HDMI-A-0";
          tray.position = "right";
        };
        "bar/right" = commonbar // {
          monitor = "DVI-D-0";
        };
        # colors
        "colors" = {
          bg = "#116530";
          fg = "#a3ebb1";
          light = "#18a558";
          signif = "21b6a8";
          trans = "#00000000";
        };
        # modules
        ## center
        "module/i3" = common_module // {
          type = "internal/i3";
          pin-workspaces = true;
          show-urgent = true;
          #strip-wsnumbers = true;
        };
        ## left
        "module/date" = common_module // {
          type = "internal/date";
          #interval = 1;
          label = "%date% %time%";
          date = "%Y-%m-%d";
          date-alt = "%A, %d %b %Y";
          time = "%H:%M:%S";
        };
        "module/cpu" = common_module // {
          type = "internal/cpu";
        };
        "module/mem" = common_module // {
          type = "internal/memory";
        };
        ## right
        "module/wlan" = common_module // {
          type = "internal/network";
          interface.type = "wireless";
          label.connected = "%ifname%@%essid%~%signal% %local_ip%";
          label.disconnected.text = "%ifname%@{!!!}";
          label.disconnected.foreground = "#ee3333";
        };
        "module/wg" = common_module // {
          type = "internal/network";
          interface = "wgnet";
          #label.connected = "";
          label.disconnected = "%ifname% DOWN";
        };
        "module/file" = common_module // {
          type = "internal/fs";
          mount = [ "/" ];
        };
        "module/round-left" = {
          type = "custom/text";
          content = "";
          content-foregound = commonbar.background;
        };
        "module/menu" = { };
      };
  };
}
