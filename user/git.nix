{ lib, pkgs, ... }: with lib; {
  # Other git-related packages
  home.packages = with pkgs; [
    gh gist
  ];

  # Git
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Celeste";
    userEmail = "celeste@foxineering.work";
    # Other config
    aliases = {
      st = "status";
      ci = "commit";
      br = "branch";
      co = "checkout";
      df = "diff";
      lg = "log --oneline --graph --decorate";
    };
    ignores = [ ".*.swp" ];
    # Config w/o existing option
    extraConfig = {
      init = { defaultBranch = "trunk"; };
    };
  };

  # Gitui cuz curious
  programs.gitui.enable = true;
}
