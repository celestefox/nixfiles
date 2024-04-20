{
  inputs = {
    # to allow non-nix 2.4 evaluation
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    # better than nixpkgs.lib
    std = {
      url = "github:chessai/nix-std";
    };
    # Nixpkgs/NixOS
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # utils
    utils.url = "github:numtide/flake-utils";
    # deployments
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };
    # self-explanatory
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    # NixOS-WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
        flake-compat.follows = "flake-compat";
      };
    };
    # ragenix
    ragenix.url = "github:yaxitech/ragenix";
    ragenix.inputs.nixpkgs.follows = "nixpkgs";
    # nixos-vscode-server
    nixos-vscode-server.url = "github:msteen/nixos-vscode-server";
    nixos-vscode-server.flake = false;
    # nixneovimplugins
    nixneovimplugins = {
      url = "github:NixNeovim/NixNeovimPlugins";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
      };
    };
    # tree
    tree.url = "github:kittywitch/tree";
    # impermanence
    impermanence.url = "github:nix-community/impermanence";
    # fenix
    #fenix.url = "github:nix-community/fenix";
    #fenix.inputs.nixpkgs.follows = "nixpkgs";
    # arcnmx/nixfiles
    arcexprs.url = "github:arcnmx/nixexprs";
    arcexprs.flake = false;
    # devenv
    #devenv.url = "github:cachix/devenv/latest";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    utils,
    ...
  }: let
    mkTree = (import (inputs.kw-nixfiles + "/mkTree.nix")) {inherit (nixpkgs) lib;};
    tree = mkTree {
      inherit inputs;
      folder = ./.;
      config = {
        "/" = {
          excludes = [
            "flake"
            "default"
            "tree"
            "inputs"
            "outputs"
            "pkgs"
            "repl"
            "shell"
          ];
        };
        "profiles/base".functor.enable = true;
        "profiles/gui".functor.enable = true;
        "profiles/wsl".functor = {
          enable = true;
          external = [
            (import inputs.nixos-wsl).nixosModules.wsl
          ];
        };
        "modules/home".functor = {
          enable = true;
          external = [
            inputs.impermanence.nixosModules.home-manager.impermanence
            (import (inputs.arcexprs + "/modules")).home-manager
            inputs.nix-index-database.hmModules.nix-index
          ];
        };
        "modules/system".functor.enable = true;
        "packages/*".aliasDefault = true;
        "services/*".aliasDefault = true;
        "users/youko".functor.enable = true;
        "users/celeste/*".functor.enable = true;
      };
    };
    nixfiles = tree.impure;
    root = ./.;
    #overlays = import nixfiles.overlays {inherit inputs system; };
  in
    {
      inherit tree;
      nixosConfigurations = with nixpkgs.lib;
        listToAttrs (
          map
          (host:
            nameValuePair host (nixosSystem {
              system = "x86_64-linux"; # TODO: i mean they all are still for now but (android?)
              specialArgs =
                {
                  inherit inputs root;
                  tree = nixfiles;
                  flake = self;
                }
                // nixfiles;
              modules = [
                # The host
                nixfiles.hosts.${host}.configuration
                # General defaults
                {system.configurationRevision = mkIf (self ? rev) self.rev;}
                # base profile
                nixfiles.profiles.base
                # Home manager
                inputs.home-manager.nixosModules.home-manager
                {
                  # global home manager
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    verbose = true;
                    # Pass flake inputs deeper
                    extraSpecialArgs =
                      {
                        inherit inputs root;
                        tree = nixfiles;
                        flake = self;
                      }
                      // nixfiles;
                    sharedModules = [
                      nixfiles.modules.home
                      # error: undefined variable 'isNixpkgsStable'
                      {disabledModules = [(inputs.arcexprs + "/modules/home/imv.nix")];}
                      #{ home.packages = [ inputs.ragenix.packages."x86_64-linux".ragenix ]; }
                    ];
                  };
                }
                # arcexprs
                (import (inputs.arcexprs + "/modules")).nixos
                # ragenix
                inputs.ragenix.nixosModules.age
                # impermanence
                inputs.impermanence.nixosModules.impermanence
                # VSCode remote fixer
                (inputs.nixos-vscode-server + "/modules/vscode-server/default.nix")
                # stylix
                inputs.stylix.nixosModules.stylix
              ];
            }))
          [
            "amaterasu"
            /*
            "okami"
            */
            "star"
          ] #(nixpkgs.lib.attrNames treated.hosts)
        );

      deploy = with inputs.deploy-rs.lib.x86_64-linux; {
        sshOpts = ["-p" "62954"];
        nodes = {
          amaterasu = {
            hostname = "amaterasu.wg.foxgirl.tech";
            profiles.system = {
              user = "root";
              path = activate.nixos self.nixosConfigurations.amaterasu;
            };
          };
          star = {
            hostname = "star.wg.foxgirl.tech";
            profiles.system = {
              user = "root";
              path = activate.nixos self.nixosConfigurations.star;
            };
          };
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
    }
    // utils.lib.eachDefaultSystem (system: let
      overlays = import nixfiles.overlays {
        inherit inputs;
        tree = nixfiles;
      };
      pkgs = import inputs.nixpkgs {
        inherit system overlays;
      };
    in {
      devShells.default = import ./shell.nix {
        inherit pkgs;
        hosts = builtins.attrNames nixfiles.hosts;
      };
      legacyPackages = pkgs;
    });
}
