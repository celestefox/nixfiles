{
  inputs = {
    # Nixpkgs/NixOS
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # flake-utils
    flake-utils.url = "github:numtide/flake-utils";
    # NixOS-WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    # home-manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # ragenix
    ragenix.url = "github:yaxitech/ragenix";
    ragenix.inputs.nixpkgs.follows = "nixpkgs";
    # nixos-vscode-server
    nixos-vscode-server.url = "github:msteen/nixos-vscode-server";
    nixos-vscode-server.flake = false;
    # kw-nixfiles
    kw-nixfiles.url = "github:kittywitch/nixfiles";
    kw-nixfiles.flake = false; # cheating cuz I just want /tree.nix for now
    # impermanence
    impermanence.url = "github:nix-community/impermanence";
    # fenix
    #fenix.url = "github:nix-community/fenix";
    #fenix.inputs.nixpkgs.follows = "nixpkgs";
    # arcnmx/nixfiles
    arcexprs.url = "github:arcnmx/nixexprs";
    arcexprs.flake = false;
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    let
      mkTree = (import (inputs.kw-nixfiles + "/tree.nix")) { inherit (nixpkgs) lib; };
      tree = mkTree {
        inherit inputs;
        folder = ./.;
        config = {
          "/" = {
            excludes = [
              "flake"
              "repl"
              "shell"
            ];
          };
          "overlays".evaluateDefault = true;
          "profiles/base".functor.enable = true;
          "profiles/gui".functor.enable = true;
          "profiles/wsl".functor = {
            enable = true;
            external = [
              (import inputs.nixos-wsl).nixosModules.wsl
            ];
          };
          "users/youko".functor.enable = true;
          "users/celeste/*".functor.enable = true;
        };
      };
      nixfiles = tree.impure;
      root = ./.;
      #overlays = import ./overlays.nix inputs;
    in
    {
      inherit tree;
      nixosConfigurations = with nixpkgs.lib; listToAttrs (map
        (host: nameValuePair host (nixosSystem {
          system = "x86_64-linux"; # TODO: i mean they all are still for now but (android?)
          specialArgs = { inherit inputs root tree; flake = self; } // nixfiles;
          modules = [
            # The host
            nixfiles.hosts.${host}.configuration
            # General defaults
            { system.configurationRevision = mkIf (self ? rev) self.rev; }
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
                extraSpecialArgs = { inherit inputs root tree; flake = self; } // nixfiles;
                sharedModules = [
                  inputs.impermanence.nixosModules.home-manager.impermanence
                  (import (inputs.arcexprs + "/modules")).home-manager
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
          ];
        }))
        [ "amaterasu" "okami" ] #(nixpkgs.lib.attrNames treated.hosts)
      );
    } // flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in {
        devShells.default = import ./shell.nix { inherit pkgs; hosts = builtins.attrNames nixfiles.hosts; };
      });
}
