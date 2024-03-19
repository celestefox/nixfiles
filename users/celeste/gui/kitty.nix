{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.kitty;
  sessionModule = {name, ...}: {
    options = {
      text = mkOption {
        type = types.lines;
        description = "Kitty session contents";
      };
      desktopEntry = {
        enable = mkEnableOption "creating desktop entry for this session" // {default = true;};
        extraArgs = mkOption {
          # TODO: replace with listOf str and use escapeShellArgs?
          type = types.str;
          description = mdDoc ''
            Extra arguments to pass to kitty when launching this session.
            The default sets the window name, to make the session window distinguishable for automation like i3 assigns.
          '';
          default = "--name ${name}";
        };
        extraOptions = mkOption {
          type = types.attrsOf types.anything;
          default = {};
          description = mdDoc "Additional options to pass to the desktop entry. Also see {option}`xdg.desktopEntries` and especially {option}`xdg.desktopEntries.<name>.settings`.";
        };
      };
    };
  };
  sessionType = types.submoduleWith {modules = [sessionModule];};
  desktopEntryFor = name: value: let
    args = value.desktopEntry.extraArgs;
  in
    {
      name = "Kitty (${name})";
      comment = "Launch kitty session ${name}";
      terminal = false;
      exec = "kitty --session ${config.xdg.configHome}/kitty/sessions/${name}${optionalString (args != "") " ${args}"}";
      icon = "kitty";
    }
    # nothing on the left is deep, so a better merge isn't required
    // value.desktopEntry.extraOptions;
in {
  options = {
    programs.kitty.sessions = mkOption {
      type = types.attrsOf sessionType;
      description = ''Kitty sessions to create'';
    };
  };

  # back to my config!
  config = {
    programs.kitty = {
      enable = true;
      # The names kitty sees for fonts are not always quite fontconfig names, see `kitty +list-fonts`
      font = lib.mkForce {
        name = "Fira Code Retina";
        size = 10;
      };
      #theme = "Rosé Pine Moon";
      settings = {
        scrollback_lines = 100000;
        enable_audio_bell = false;
        #background_opacity = "0.9";
        dynamic_background_opacity = true;
        allow_remote_control = true;
        update_check_interval = 0;
        editor = "nvim";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
      };
      keybindings = {
        "ctrl+shift+p>n" = "kitten hints --type linenum --linenum-action=tab nvim +{line} {path}";
        "ctrl+shift+p>e" = ''kitten hints --type path --program "launch --type=tab nvim"'';
        "ctrl+alt+enter" = ''launch --cwd=current'';
      };
      extraConfig = ''
        modify_font underline_position 2
        # originally for v2.3.3, updated to v3.1.1 by celeste
        symbol_map U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6B2,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F372,U+F400-U+F532,U+F0001-U+F1AF0 Symbols Nerd Font Mono
      '';
      sessions = {
        status = {
          text = ''
            new_tab System journal
            launch journalctl -fn 1000

            new_tab User journal
            launch journalctl --user -fn 1000

            new_tab bluetoothctl
            launch bluetoothctl
          '';
        };
      };
    };

    # "part" of the kitty config in my mind - it uses kitty in a cli manner
    # and it's a separate alias because I don't always want the kitten, even in kitty, so no overriding
    programs.fish = {
      shellAliases = {
        s = "kitty +kitten ssh";
      };
    };

    # ibus for kitty? prolly good for others? TODO: new im to replace ibus?
    #home.sessionVariables."GLFW_IM_MODULE" = "ibus";

    # the pseudo-session-module's config bit:

    # dunno if this is the best place to store them but it works
    xdg.configFile =
      mkIf (cfg.sessions != {})
      (mapAttrs' (name: value: nameValuePair "kitty/sessions/${name}" {inherit (value) text;}) cfg.sessions);

    # Make the desktop entries
    xdg.desktopEntries =
      mkIf (cfg.sessions != {})
      # make the desktop entry
      (mapAttrs' (name: value: nameValuePair "kitty-session-${name}" (desktopEntryFor name value))
        # only for sessions it is enabled for, however
        (filterAttrs (_: v: v.desktopEntry.enable) cfg.sessions));
  };
}
