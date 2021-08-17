{ ... }:

{
  imports = [
    ./git.nix
    ./base16.nix
    ./packages.nix
    ./pass.nix
    ./secrets.nix
  ];

  home.stateVersion = "21.11";
}
