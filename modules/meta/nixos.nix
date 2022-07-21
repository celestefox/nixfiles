{ pkgs, inputs, lib, config, ... }: with lib; {
  options = {
    nixosConfigurations =
      let
        nixosModule = {}: { };
        modulesPath = inputs.nixpkgs.outPath + "/nixos/modules";
        baseModules = import (modulesPath + "/module-list.nix");
        nixosType = types.submoduleWith {
          modules = baseModules
            ++ singleton nixosModule;
          specialArgs = {
            inherit modulesPath baseModules inputs flake;
          } // nixpkgs;
        };
      in
      mkOption {
        type = types.attrsOf nixosType;
      };
  };
}
