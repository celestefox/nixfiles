{ lib, pkgs, ... }: with lib; {
  # General
  home = {
    # Variables
    sessionVariables = {
      EDITOR = "nvim";
      LESS = "-FSR";
      #BROWSER = "/mnt/c/Program Files/Firefox Developer Edition/firefox.exe";
    };
    
    # Packages not covered by other options
    packages = with pkgs; [
      bat-extras.batman
      man-pages man-pages-posix
      wget curl
    ];
  };

  # Fish
  programs.fish = {
    enable = true;
    functions = let exacmd = "exa --icons --git --color=always "; lesscmd = " | less -FSR"; in {
      ls  = { wraps = "exa"; body = exacmd + "$argv" + lesscmd; };
      ll  = { wraps = "exa"; body = exacmd + "--long $argv" + lesscmd; };
      la  = { wraps = "exa"; body = exacmd + "--all $argv" + lesscmd; };
      lt  = { wraps = "exa"; body = exacmd + "--tree $argv" + lesscmd; };
      lla = { wraps = "exa"; body = exacmd + "--long --all $argv" + lesscmd; };
      l   = { wraps = "exa"; body = exacmd + "--long --all $argv" + lesscmd; };
    };
  };
  programs.starship.enable = true;
  programs.nix-index.enable = true;

  # Dircolors
  programs.dircolors.enable = true;

  # exa
  programs.exa = {
    enable = true;
    # replaced w/ custom aliases for adtl arg support
    #enableAliases = true;
  };

  # bat
  programs.bat.enable = true;

  # fzf
  programs.fzf.enable = true;

  # Gimme docs
  manual = { manpages.enable = true; html.enable = true; };
  programs.man.generateCaches = true;
}
