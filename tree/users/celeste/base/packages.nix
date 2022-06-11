{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    tmate
    htop
    pstree
    fd
    sd
    duc
    bat
    exa
    netcat
    socat
    rsync
    curl
    wget
    ripgrep
    nixpkgs-fmt
    pv
    progress
    zstd
    file
    atool
    unzip
    whois
    niv
    ldns
    dnsutils
    neofetch
    units
  ];
}
