{ lib, pkgs, ... }: with lib; {
  # Fish pls
  users.defaultUserShell = pkgs.fish;
  programs.fish = {
    enable = true;
  };

  # Dun want the default shell aliases...
  environment.shellAliases = mkForce {
    l = null;
    ls = null;
    ll = null;
  };
}
