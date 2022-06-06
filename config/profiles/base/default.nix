{ config, meta, lib, pkgs, ... }:

{
  imports = with meta; [
    users.celeste.base
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
