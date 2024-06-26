{
  config,
  lib,
  inputs,
  ...
}: {
  # from kat
  nix = {
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "home-manager=${inputs.home-manager}"
      #"nur=${inputs.nur}"
      "arc=${inputs.arcexprs}"
    ];
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      home-manager.flake = inputs.home-manager;
      #nur.flake = inputs.nur;
      arc.flake = inputs.arcexprs;
    };
    settings = {
      experimental-features = lib.optional (lib.versionAtLeast config.nix.package.version "2.4") "nix-command flakes";
      substituters = [
        "https://arc.cachix.org"
        "https://kittywitch.cachix.org"
        "https://nix-community.cachix.org"
        "https://celestefox.cachix.org"
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY="
        "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
        "celestefox.cachix.org-1:HYx6fQTddoa35GnpTu+9NwzvaWKpr13E+cToR60j+KE="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
    };
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };
}
