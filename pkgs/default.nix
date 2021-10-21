{ sources, system ? builtins.currentSystem, ... }@args:

let
  overlay = self: super: {
    nur = import sources.nur {
      nurpkgs = self;
      pkgs = self;
    };
  };
  localpkgs = self: super: {
    static-site = self.callPackage ./static-site { };
  };
  pkgs = import sources.nixpkgs {
    overlays = [
      (import (sources.arcexprs + "/overlay.nix"))
      (import (sources.katexprs + "/overlay.nix"))
      localpkgs
      overlay
    ];
    config = {
      allowUnfree = true;
    };
  };
in pkgs
