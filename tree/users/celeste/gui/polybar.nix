{ config, lib, pkgs, ... }: with lib; {
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      pulseSupport = true;
      iwSupport = true;
      githubSupport = true;
    };
    script = ''
      polybar left &
      polybar right &
    '';
    settings = let commonbar = {
      background = "#1b181b";
      foreground = "#ab9bab";
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
        # modules
        ## center
        "module/i3" = {
          type = "internal/i3";
          pin-workspaces = true;
          show-urgent = true;
          strip-wsnumbers = true;
        };
        ## left
        "module/date" = {
          type = "internal/date";
          #interval = 1;
          label = "%date% %time%";
          date = "%Y-%m-%d";
          date-alt = "%A, %d %b %Y";
          time = "%H:%M:%S";
        };
        "module/cpu" = {
          type = "internal/cpu";
        };
        "module/mem" = {
          type = "internal/memory";
        };
        ## right
        "module/wlan" = {
          type = "internal/network";
          interface.type = "wireless";
          label.connected = "%ifname%@%essid%~%signal% %local_ip%";
          label.disconnected.text = "%ifname%@{!!!}";
          label.disconnected.foreground = "#ee3333";
        };
        "module/wg" = {
          type = "internal/network";
          interface = "wgnet";
          #label.connected = "";
          label.disconnected = "%ifname% DOWN";
        };
        "module/file" = {
          type = "internal/fs";
          mount = [ "/" ];
        };
        "module/menu" = { };
      };
  };
}
