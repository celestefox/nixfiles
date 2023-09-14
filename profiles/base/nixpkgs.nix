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
      permittedInsecurePackages = [
        "openssl-1.1.1v" # see users/celeste/gui/gaymes, for steam-run, for Stardew Valley
      ];
    };
  };
}
