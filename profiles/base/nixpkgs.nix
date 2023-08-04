{
  inputs,
  tree,
  overlays,
  ...
}: {
  nixpkgs = {
    overlays = import overlays {
      inherit inputs tree;
    };
    config = {
      allowUnfree = true;
      allowBroken = true; # vimExtraPlugins.go-nvim
    };
  };
}
