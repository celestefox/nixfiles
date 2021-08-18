{ config, lib, pkgs, sources, ... }:

{
  boot.loader.grub.configurationLimit = 8;
  boot.loader.systemd-boot.configurationLimit = 8;

  nix = {
    nixPath = [
      "nixpkgs=${sources.nixpkgs}"
      "nur=${sources.nur}"
      "arc=${sources.arcexprs}"
      "ci=${sources.ci}"
    ];
    sandboxPaths = [
      "/var/run/nscd/socket"
    ];
    binaryCaches = [ "https://arc.cachix.org" "https://kittywitch.cachix.org" ];
    binaryCachePublicKeys =
      [ "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=" "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0=" ];
    autoOptimiseStore = true;
    gc.automatic = lib.mkDefault true;
    gc.options = lib.mkDefault "--delete-older-than 1w";
    trustedUsers = [ "root" "@wheel" ];
  };
}
