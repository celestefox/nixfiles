{ config, meta, lib, pkgs, ... }:

{
  imports = with meta; [
    # SETUP Replace user example
    users.youko.base
    ./system.nix
    ./home.nix
    ./profiles.nix
    ./shell.nix
    ./base16.nix
    ./net.nix
    ./access.nix
    ./locale.nix
    ./nix.nix
    ./ssh.nix
    ./packages.nix
    ./secrets.nix
  ];
}
