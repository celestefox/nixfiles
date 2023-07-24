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
      config = {
        #desktopEntry.extraArgs = mkDefault " --name ${name}";
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
  config = {
    /*
         nixpkgs.overlays = [
      (final: prev: {
        # doin this should be fine for now. security updates not likely at all, i only needed the newer theme,
        # and i wanna switch to base16 sometime, which will probably mean adding an include line of it instead
        kitty-themes = prev.kitty-themes.overrideAttrs
          (old: {
            src = prev.fetchFromGitHub
              {
                owner = "kovidgoyal";
                repo = old.pname;
                rev = "f6c2f4e5617ef946b17db8bc18dadc9fad38d32e";
                sha256 = "SM7ExyD6cCYXZwxb4Rs1U2P2N9vzhmaUHJJRz/gO3IQ=";
              };
          });
      })
    ];
    */

    programs.kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font Mono Ret";
        size = 10;
      };
      theme = "Rosé Pine Moon";
      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;
        background_opacity = "0.9";
        dynamic_background_opacity = true;
        allow_remote_control = true;
        update_check_interval = 0;
        shell_integration = "enabled no-rc";
        editor = "nvim";
      };
      #keybindings = let nav = mew; in {
      #  "ctrl+j" = ""
      #};
      keybindings = {
        "ctrl+shift+p>n" = "kitten hints --type linenum --linenum-action=tab nvim +{line} {path}";
        "ctrl+shift+p>e" = ''kitten hints --type path --program "launch --type=tab nvim"'';
      };
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

    programs.fish = {
      shellAliases = {
        s = "kitty +kitten ssh";
      };
    };

    # dunno if this is the best place to store them but it works
    xdg.configFile =
      mkIf (cfg.sessions != {})
      (mapAttrs' (name: value: nameValuePair "kitty/sessions/${name}" {inherit (value) text;}) cfg.sessions);

    # hardcoded fr now
    # xdg.desktopEntries.kitty-session-status = {
    #   name = "Kitty (Status)";
    #   comment = "Launch kitty session status";
    #   terminal = false;
    #   #tryExec = "kitty";
    #   # --name isn't part of the session, it's for i3 instead, the workspace assign
    #   exec = "kitty --session ${config.xdg.configHome}/kitty/sessions/status --name status";
    #   icon = "kitty";
    # };
    xdg.desktopEntries =
      mkIf (cfg.sessions != {})
      # make the desktop entry
      (mapAttrs' (name: value: nameValuePair "kitty-session-${name}" (desktopEntryFor name value))
        # only for enabled sessions, though
        (filterAttrs (_: v: v.desktopEntry.enable) cfg.sessions));

    # ibus for kitty? prolly good for others?
    home.sessionVariables."GLFW_IM_MODULE" = "ibus";
  };
}
