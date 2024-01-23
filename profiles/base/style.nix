{
  pkgs,
  lib,
  ...
}: {
  stylix = {
    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/96/wallhaven-96kk6w.png";
      hash = "sha256-s95v4AeCi5u35kXOj5lXvaRuPqTbD+zdWILh9eg3feg=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    fonts = {
      monospace = {
        name = "FiraCode Nerd Font Mono";
        package = pkgs.nerdfonts;
      };
    };
    opacity.terminal = 0.9;
    targets = {
      nixvim.enable = false;
    };
  };
}
