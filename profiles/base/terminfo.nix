{pkgs, ...}: {
  # a limited selection, vs environment.enableAllTerminfo
  environment.systemPackages = map (x: x.terminfo) (with pkgs; [
    kitty
    foot
    tmux
  ]);
}
