{ inputs, system ? builtins.currentSystem or "x86_64-linux", ... }@args:
let
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      (import ./local)
      (import "${inputs.arcexprs}/overlay.nix")
      inputs.ragenix.overlays.default
      inputs.nixneovimplugins.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };
in
pkgs
