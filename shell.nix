{ pkgs ? import <nixpkgs> { }
, hosts ? [ "star" ] # list of strings
, username ? "celeste"
}: with pkgs.lib; let
  scripts = mapAttrsToList pkgs.writeShellScriptBin ({
    "localhost-rebuild" = ''exec nixos-rebuild --flake "${toString ./.}" --use-remote-sudo --verbose "$@"'';
    "nixfiles-repl" = ''exec nix repl "${toString ./.}/repl.nix"'';
    "previewage" = ''tail +2 "''${1:--}" | head -n -1 | base64 -d'';
  }
  // (foldl' (prev: curr: prev // curr) { } (map
    (hostname: {
      "${hostname}-rebuild" = ''
        exec nixos-rebuild --flake "${toString ./.}#${hostname}" --target-host ${username}@${hostname} --use-remote-sudo --verbose "$@"
      '';
    })
    hosts)));
in
pkgs.mkShell {
  buildInputs = [ ] ++ scripts;
  shellHook = ''
    export HOME_HOSTNAME=$(hostname -s)
    export HOME_UID=$(id -u)
    export HOME_USER=$(id -un)
    export NIX_PATH="$NIX_PATH:home=${toString ./.}"
  '';
}
