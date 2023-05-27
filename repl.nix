let
  flake = builtins.getFlake (toString ./.);
  pkgs = import ./overlays { inherit (flake) inputs; system = builtins.currentSystem or "x86_64-linux"; };
in
{ inherit flake pkgs; inherit (pkgs) lib; }
// flake
// flake.nixosConfigurations
