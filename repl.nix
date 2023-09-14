let
  flake = builtins.getFlake (toString ./.);
  tree = flake.tree.impure;
  overlays = import tree.overlays {
    inherit (flake) inputs;
    inherit tree;
  };
  pkgs = import flake.inputs.nixpkgs {
    inherit overlays;
    system = builtins.currentSystem or "x86_64-linux";
    config = {allowUnfree = true;};
  };
  #pkgs = import ./overlays { inherit (flake) inputs; system = builtins.currentSystem or "x86_64-linux"; };
in
  {
    inherit flake pkgs;
    inherit (pkgs) lib;
  }
  // flake
  // flake.nixosConfigurations
