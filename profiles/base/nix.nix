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
      "kw-nixfiles=${inputs.kw-nixfiles}"
    ];
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      home-manager.flake = inputs.home-manager;
      #nur.flake = inputs.nur;
      arc.flake = inputs.arcexprs;
      #ci.flake = inputs.ci;
      #kw-nixfiles = inputs.kw-nixfiles; #oops not a flake, but still want it in
    };
    settings = {
      experimental-features = lib.optional (lib.versionAtLeast config.nix.package.version "2.4") "nix-command flakes";
      substituters = [
        "https://arc.cachix.org"
        "https://kittywitch.cachix.org"
        "https://nix-community.cachix.org"
        "https://celestefox.cachix.org"
      ];
      trusted-public-keys = [
        "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY="
        "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
        "celestefox.cachix.org-1:HYx6fQTddoa35GnpTu+9NwzvaWKpr13E+cToR60j+KE="
      ];
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
