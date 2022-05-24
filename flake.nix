{
  inputs = {
    # Nixpkgs/NixOS
    nixpkgs.url = "nixpkgs/nixos-unstable";
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
  };
  
  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.okami = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Pass inputs
	{ _module.args.inputs = inputs; }

	# Give nixos-version the Git rev
	{ system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev; }

	# Top level general config!
        ./configuration.nix

        # NixOS-WSL
        inputs.nixos-wsl.nixosModules.wsl

	# Home manager
	home-manager.nixosModules.home-manager

	# ragenix
	inputs.ragenix.nixosModules.age

	# VSCode remote fixer
	(inputs.nixos-vscode-server + "/modules/vscode-server/default.nix")
      ];
    }; 
  };
}
