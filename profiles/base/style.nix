{pkgs, ...}: {
  stylix = {
    # while this isn't seen much in practice because konawall, this still shows up before first konawall fetch and maybe other places
    # it also is still what a colorscheme is generated from in the absense of a base16Scheme
    # see user/celeste/gui/konawall.nix; konaoff sets this as the background again
    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/96/wallhaven-96kk6w.png";
      hash = "sha256-s95v4AeCi5u35kXOj5lXvaRuPqTbD+zdWILh9eg3feg=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    cursor = {
      package = pkgs.vimix-cursors;
      name = "Vimix-cursors";
      size = 24;
    };
    fonts = {
      monospace = {
        name = "Fira Code";
        package = pkgs.fira-code;
      };
    };
    opacity.terminal = 0.9;
    targets = {
      nixvim.enable = false;
    };
  };
}
