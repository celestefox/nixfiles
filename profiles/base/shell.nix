{
  lib,
  pkgs,
  ...
}: {
  # Fish pls
  users.defaultUserShell = pkgs.fish;
  programs.fish = {
    enable = true;
  };

  # Dun want the default shell aliases...
  environment.shellAliases = lib.mkForce {
    l = null;
    ls = null;
    ll = null;
  };

  # kitten everywhere
  environment.systemPackages = lib.singleton pkgs.kitty.kitten;
}
