{ lib, pkgs, ... }: with lib; {
  # Other git-related packages
  home.packages = with pkgs; [
    gist tea glab
  ];

  # Git
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Celeste";
    userEmail = "celeste@foxgirl.tech";
    signing = {
      # key = "0x361D4D533A25164A";
      key = "0xE642875C488F6874";
      signByDefault = true;
    };
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
      url = {
        # go, TODO: alt git auth methods for gitlab?
        "ssh://git@gitlab.com/".insteadOf = "https://gitlab.com/";
      };
    };
  };

  # gh
  programs.gh = {
    enable = true;
    #settings.git_protocol = "ssh";
  };

  # Gitui cuz curious
  programs.gitui.enable = true;
}
