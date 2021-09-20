{ sources, system ? builtins.currentSystem, ... }@args:

let
  overlay = self: super: {
    nur = import sources.nur {
      nurpkgs = self;
      pkgs = self;
    };
  };
  pkgs = import sources.nixpkgs {
    overlays = [
      (import (sources.arcexprs + "/overlay.nix"))
      (import (sources.katexprs + "/overlay.nix"))
      overlay
    ];
    config = {
      allowUnfree = true;
    };
  };
in pkgs
