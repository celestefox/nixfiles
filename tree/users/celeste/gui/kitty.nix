{ ... }: {
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

  programs.kitty = {
    enable = true;
    font = {
      name = "Fira Code Regular Nerd Font Complete";
      size = 10;
    };
    theme = "Rosé Pine";
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      background_opacity = "0.9";
      dynamic_background_opacity = true;
      allow_remote_control = true;
      update_check_interval = 0;
    };
    #keybindings = let nav = mew; in {
    #  "ctrl+j" = ""
    #};
  };
}
