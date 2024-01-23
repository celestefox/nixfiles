{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      package = pkgs.rose-pine-gtk-theme;
      name = "rose-pine-moon";
    };
  };
}
