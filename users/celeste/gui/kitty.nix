{ ... }: {
  /*   nixpkgs.overlays = [
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
  ]; */

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
    };
  };

  programs.fish = {
    shellInit = ''
      if set -q KITTY_INSTALLATION_DIR
        # https://sw.kovidgoyal.net/kitty/shell-integration/#manual-shell-integration sets K_S_I here
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
      end
    '';
    shellAliases = {
      s = "kitty +kitten ssh";
    };
  };


  # ibus for kitty? prolly good for others?
  home.sessionVariables."GLFW_IM_MODULE" = "ibus";
}
