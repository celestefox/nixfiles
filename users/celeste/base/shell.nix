{
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
  # General
  home = {
    # Variables
    sessionVariables = {
      EDITOR = "nvim";
      LESS = "-FSRM";
    };

    # Add some more directories to PATH
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/bin"
    ];

    # Packages not covered by other options
    packages = with pkgs; [
      bat-extras.batman
      man-pages
      man-pages-posix
      wget
      curl
    ];
  };

  # Fish
  programs.fish = {
    enable = true;
    functions = let
      exaOf = args: {
        wraps = "exa";
        body = "exa --icons --git --color=always --time-style=long-iso ${args}";
      };
    in {
      killjobs = {
        description = "Kill all jobs";
        body = "kill (jobs -p)";
      };
      ls = exaOf "$argv";
      ll = exaOf "--long $argv";
      la = exaOf "--all $argv";
      lt = exaOf "--tree $argv";
      lla = exaOf "--long --all $argv";
      l = exaOf "--long --all $argv";
    };
    shellInit = ''
      string match -q "$TERM_PROGRAM" "vscode"
      and set -x EDITOR "code -rw"
    '';
  };

  # Bash - mostly, just, make sure integrations are also setup here by default in hopes
  # of it being nicer when I need it over fish
  programs.bash.enable = true;

  programs.tmux = {
    enable = true;
    #newSession = true;
    clock24 = true;
    # https://github.com/tmux/tmux/wiki/FAQ#what-is-the-escape-time-option-is-zero-a-good-value
    # home-manager thinks this's in milliseconds, so I'm trying 50
    escapeTime = 50;
    shortcut = "a";
    historyLimit = 50000;
    terminal = "tmux-256color";
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.tmux-fzf;
        extraConfig = ''
          TMUX_FZF_LAUNCH_KEY="C-f"
        '';
      }
    ];
    extraConfig = ''
      set -g set-titles on
      set -as terminal-features ",xterm*:RGB,vscode:RGB"
    '';
  };
  programs.tmate = {
    enable = true;
    # TODO: plugins probably don't work w/ tmate by default?
    # Just due to how "plugins" are closer to external bash scripts...
    # they generally (certainly tmux-fzf does) just seem to run "tmux"
    # Maybe some sort of "tmux" -> "tmate" while within tmate?
    # I'd also have to actually make use of tmate for me to care about this...
    extraConfig = ''source-file ${config.xdg.configFile."tmux/tmux.conf".source}'';
  };

  programs.starship = {
    enable = true;
    settings = {
      aws.disabled = true;
      shell = {
        disabled = false;
        # don't display anything for fish, only other shells
        fish_indicator = "";
        # default one ends w/ a space, which renders before the ❯ from character
        format = "[$indicator]($style)";
      };
    };
  };
  programs.nix-index.enable = true;
  programs.direnv.enable = true;

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

  # zoxide
  programs.zoxide.enable = true;

  programs.info.enable = true;

  # Gimme docs
  manual = {
    manpages.enable = true;
    html.enable = true;
  };
  programs.man.generateCaches = true;
}
