{ pkgs ? import <nixpkgs> { }
, hosts ? [ "star" ] # list of strings
, username ? "celeste"
}: with pkgs.lib; let
  scripts = mapAttrsToList pkgs.writeShellScriptBin ({
    "localhost-rebuild" = ''
      nixos-rebuild --flake "${toString ./.}" --use-remote-sudo --verbose "$@"
    ''; # [[ $? -eq 0 && $1 == "switch" ]] && journalctl -o cat --no-pager "_SYSTEMD_INVOCATION_ID=$(systemctl show --value -p InvocationID home-manager-$(id -un).service)"
    "nixfiles-repl" = ''exec nix repl "${toString ./.}/repl.nix"'';
    "previewage" = ''tail +2 "''${1:--}" | head -n -1 | base64 -d'';
  }
  // (foldl' (prev: curr: prev // curr) { } (map
    (hostname: {
      "${hostname}-rebuild" = ''
        exec nixos-rebuild --flake "${toString ./.}#${hostname}" --target-host ${username}@${hostname} --use-remote-sudo --use-substitutes --verbose "$@"
      '';
    })
    hosts)));
in
pkgs.mkShell {
  buildInputs = [ pkgs.nix-prefetch-github pkgs.nix-prefetch-git ] ++ scripts;
  shellHook = ''
    export HOME_HOSTNAME=$(hostname -s)
    export HOME_UID=$(id -u)
    export HOME_USER=$(id -un)
    export NIX_PATH="$NIX_PATH:home=${toString ./.}"
    # Starship uses to determine nix shell name
    # unfortunately, looks like this doesn't get reset by either type of nix shell while in a nix-shell direnv
    export name=nf-shell
  '';
}
