{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.celeste.ss;
  dropNlines = lines: text: lib.strings.concatStringsSep "\n" (lib.lists.drop lines (lib.strings.splitString "\n" text)); # probably inefficient
  pkg = pkgs.writeShellApplication {
    name = "ss";
    runtimeInputs = builtins.attrValues {inherit (pkgs) shotgun hacksaw rclone xclip xdotool dunst;};
    text = dropNlines 3 (builtins.readFile ./ss.bash); # So I can instead have a nix-shell header in the in-repo script
  };
in {
  options = {
    celeste.ss = {
      package = mkOption {
        type = types.package;
        default = pkg;
        defaultText = literalExpression "writeShellApplication { ...; text = dropNlines 3 (builtins.readFile ./ss.bash); }";
        description = "the ss script derivation";
      };
    };
  };
  config = {
    home.packages = singleton cfg.package;
  };
}
