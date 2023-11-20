{
  pkgs ? import <nixpkgs> {},
  hosts ? ["star"], # list of strings
  username ? "celeste",
}:
with pkgs.lib; let
  scripts = mapAttrsToList pkgs.writeShellScriptBin ({
      "localhost-rebuild" = ''
        nixos-rebuild --flake "${toString ./.}" --use-remote-sudo --verbose "$@"
      ''; # [[ $? -eq 0 && $1 == "switch" ]] && journalctl -o cat --no-pager "_SYSTEMD_INVOCATION_ID=$(systemctl show --value -p InvocationID home-manager-$(id -un).service)"
      "nixfiles-repl" = ''exec nix repl "${toString ./.}/repl.nix"'';
      "previewage" = ''tail +2 "''${1:--}" | head -n -1 | base64 -d'';
    }
    // (foldl' (prev: curr: prev // curr) {} (map
      (hostname: {
        "${hostname}-rebuild" = ''
          exec nixos-rebuild --flake "${toString ./.}#${hostname}" --target-host ${username}@${hostname} --use-remote-sudo --use-substitutes --verbose "$@"
        '';
      })
      hosts)));
in
  pkgs.mkShell {
    name = "nf-shell";
    buildInputs =
      [
        pkgs.nix-prefetch-github
        pkgs.nix-prefetch-git
        pkgs.deadnix # dead-code scanner
        pkgs.alejandra # code formatter
        pkgs.statix # anti-pattern finder
        pkgs.nil # language server
        pkgs.deploy-rs.deploy-rs # new deploys?
      ]
      ++ scripts;
    shellHook = ''
      export HOME_HOSTNAME=$(hostname -s)
      export HOME_UID=$(id -u)
      export HOME_USER=$(id -un)
      export NIX_PATH="$NIX_PATH:home=${toString ./.}"
    '';
  }
