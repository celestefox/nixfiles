{
  config,
  lib,
  pkgs,
  ...
}: {
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
    httpie
    ldns
    dnsutils
    whois
    ripgrep
    nixpkgs-fmt
    pv
    progress
    file
    atool # tar, gzip, some others already end up in my path for it
    zstd
    zip
    unzip # it, lock it, fill it, call it, find it, view it, code it, jam, unlock it
    unrar-wrapper # instead of original unfree unrar, uses unar
    niv
    neofetch
    units # `units -v`'s amazing
    cachix
    qmk # board of keys
  ];

  programs.aria2.enable = true;
}
