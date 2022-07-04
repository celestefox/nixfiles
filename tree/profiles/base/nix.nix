{ config, lib, pkgs, inputs, ... }:

{
  # from kat
  nix = {
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "home-manager=${inputs.home-manager}"
      #"nur=${inputs.nur}"
      "arc=${inputs.arcexprs}"
      #"ci=${inputs.ci}"
    ];
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      home-manager.flake = inputs.home-manager;
      #nur.flake = inputs.nur;
      arc.flake = inputs.arcexprs;
      #ci.flake = inputs.ci;
    };
    settings = {
      experimental-features = lib.optional (lib.versionAtLeast config.nix.package.version "2.4") "nix-command flakes";
      # todo: add my own cachix store too for sure
      substituters = [ "https://arc.cachix.org" "https://kittywitch.cachix.org" "https://nix-community.cachix.org" ];
      trusted-public-keys =
        [ "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=" "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };
}
