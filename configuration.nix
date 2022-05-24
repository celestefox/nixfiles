{ lib, pkgs, config, modulesPath, inputs, ... }: with lib; {
  # Hostname! heckin mess of nixy stuff
  networking.hostName = "okami";

  # TZ
  time.timeZone = "America/Denver";

  # Locales (minimal)
  i18n.defaultLocale = "en_US.UTF-8"; # is default anyways but
  i18n.supportedLocales = [ (config.i18n.defaultLocale + "/UTF-8") ];

  # weh
  environment.noXlibs = false;
  documentation.enable = true;
  documentation.nixos.enable = true;
  programs.command-not-found.enable = false; # replaced w/ nix-index in home.nix cuz flakes

  # Home manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Pass flake inputs deeper
    sharedModules = [ { _module.args.inputs = inputs; } ];
    users.nixos = import ./user/default.nix;
  };

  # Fish pls
  users.defaultUserShell = pkgs.fish;
  programs.fish = {
    enable = true;
  };

  # Dun want the default shell aliases...
  environment.shellAliases = mkForce {
    l = null; ls = null; ll = null;
  };

  # Neovim for editor
  programs.neovim = {
    enable = true;
    #defaultEditor = true;
    /*
    configure = {
      customRC = ''
        " Config here :o
      '';
      packages.myvim = with pkgs.vimPlugins; {
        # Loaded at start
        start = [
	  vim-sensible
	  vim-eunuch
	  vim-nix
	  nvim-lspconfig
	];
	# Loadable with `:packadd $name`
      };
    };
    */
  };

  # Fix up VSCode remote server
  services.vscode-server.enable = true;

  # WSL config
  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Pin nixpkgs to system flake ver
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  # System state version, be careful changing
  system.stateVersion = "22.05";
}
