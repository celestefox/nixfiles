{ config, lib, nixos, ... }:

with lib;

{
  options = {
    deploy.profile = {
      gui = mkEnableOption "Graphical System";
      hardware = {
        amdgpu = mkEnableOption "AMD GPU";
        intel = mkEnableOption "Intel CPU";
        laptop = mkEnableOption "Laptop";
        wifi = mkEnableOption "WiFi, home network";
        ryzen = mkEnableOption "AMD Ryzen CPU";
      };
    };
    home-manager.users = mkOption {
      type = types.attrsOf (types.submoduleWith {
        modules = [
          ({ nixos, ... }: {
            options.deploy.profile = {
              gui = mkEnableOption "Graphical System";
              hardware = {
                amdgpu = mkEnableOption "AMD GPU";
                intel = mkEnableOption "Intel CPU";
                laptop = mkEnableOption "Laptop";
                wifi = mkEnableOption "WiFi, home network";
                ryzen = mkEnableOption "AMD Ryzen CPU";
              };
            };
            config = {
              deploy.profile = nixos.deploy.profile;
            };
          })
        ];
      });
    };
  };
}
