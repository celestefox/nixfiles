{
  inputs,
  tree,
  overlays,
  ...
}: {
  nixpkgs = {
    overlays = import overlays {
      # glue
      tree = tree.impure;
      inherit inputs;
    };
    config = {
      allowUnfree = true;
      allowBroken = true; # vimExtraPlugins.go-nvim
    };
  };
}
