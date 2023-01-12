{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
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
    rclone
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

  programs.aria2.enable = true;
}
