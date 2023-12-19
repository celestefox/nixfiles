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
        wraps = "eza";
        body = "eza --hyperlink --icons --git --git-repos --color=always --time-style=long-iso ${args}";
      };
    in {
      killjobs = {
        description = "Kill all jobs";
        body = "kill (jobs -p)";
      };
      batman = {
        # wrapper for completion's sake
        wraps = "man";
        body = ''
          # This is adapted from the man function provided by fish itself.
          # Work around the "builtin" manpage that everything symlinks to,
          # by prepending our fish datadir to man. This also ensures that man gives fish's
          # man pages priority, without having to put fish's bin directories first in $PATH.

          # Preserve the existing MANPATH, and default to the system path (the empty string).
          set -l manpath
          if set -q MANPATH
              set manpath $MANPATH
          else # Branch above here depending on the implementation of the man command removed as it d
              set manpath '''
          end
          # Notice the shadowing local exported copy of the variable.
          set -lx MANPATH $manpath

          # Prepend fish's man directory if available.
          set -l fish_manpath $__fish_data_dir/man
          if test -d $fish_manpath
              set MANPATH $fish_manpath $MANPATH
          end

          if test (count $argv) -eq 1
              # Some of these don't have their own page,
              # and adding one would be awkward given that the filename
              # isn't guaranteed to be allowed.
              # So we override them with the good name.
              switch $argv
                  case :
                      set argv true
                  case '['
                      set argv test
                  case .
                      set argv source
              end
          end

          command batman $argv
        '';
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
      nix_shell = {
        #heuristic = true;
      };
    };
  };
  programs.nix-index.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Dircolors
  programs.dircolors.enable = true;

  # eza, from exa
  programs.eza.enable = true;

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
