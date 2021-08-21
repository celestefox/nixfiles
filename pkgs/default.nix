{ sources, system ? builtins.currentSystem, ... }@args:

let
  liboverlay = self: super: {
    lib = super.lib.extend (self: super: import ../lib {
      inherit super;
      lib = self;
      isOverlayLib = true;
    });
  };
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
      liboverlay
      overlay
    ];
    config = {
      allowUnfree = true;
    };
  };
in pkgs
