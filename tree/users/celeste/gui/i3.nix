{ config, lib, pkgs, ... }: {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      # Default modifier key
      modifier = "Mod4";
      # Terminal to use
      terminal = "kitty";
      # Auto back and forth
      workspaceAutoBackAndForth = true;
      # no bars mew
      bars = lib.mkForce [];
      # keybindings
      keybindings =
        let
          modifier = config.xsession.windowManager.i3.config.modifier;
          rofi = config.programs.rofi.finalPackage + "/bin/rofi";
        in
        lib.mkOptionDefault {
          # Running
          "${modifier}+r" = "exec ${rofi} -show run";
          "${modifier}+d" = ''exec --no-startup-id ${dunstify} -u critical -t 2000 "use win+r!"'';
          # Modes
          "${modifier}+s" = "mode resize"; #For size instead
          # Layout
          "${modifier}+l" = "layout toggle all"; #and thus l to cycle layouts
          # Switch workplace between screens
          "${modifier}+x" = "move workspace to output right";
          # TODO: workplace setup (workspaces are dynamic, so configured as keybinds!)
          "${modifier}+grave" = "workspace 0:~"; # TODO: replace grave binds w/ quake terminal stuff?
          "${modifier}+Shift+grave" = "move container to workspace number 0:~";
          "${modifier}+minus" = "workspace 11:-";
          "${modifier}+Shift+minus" = "move container to workspace number 11:-";
          "${modifier}+equal" = "workspace 12:=";
          "${modifier}+Shift+equal" = "move container to workspace number 12:=";
          "${modifier}+BackSpace" = "workspace 13:←";
          "${modifier}+Shift+BackSpace" = "move container to workspace 13:←";
          "${modifier}+o" = "exec --no-startup-id screenshot selection";
        };
      # Disable builtin bars (for polybar, eventually)
      #bars = [];
      # Gaps settings
      gaps = {
        inner = 6;
        outer = 12;
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
