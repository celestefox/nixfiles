let
  flake = builtins.getFlake (toString ./.);
  pkgs = import <nixpkgs> { };
in
{ inherit flake pkgs; inherit (pkgs) lib; }
// flake
// flake.nixosConfigurations
