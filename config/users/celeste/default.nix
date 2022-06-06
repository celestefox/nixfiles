let youkoUser = { lib }:
  let
    userImport = profile: { config, ... }: {
      config.home-manager.users.celeste = {
        imports = [
          (./. + "/${profile}")
        ];
      };
    };
    serviceImport = profile: { config, ... }: {
      config.home-manager.users.celeste = {
        imports = [
          (./services + "/${profile}")
        ];
      };
    };
    profileNames = lib.folderList ./. [ "base" "services" ];
    serviceNames = lib.folderList ./services [ ];
    userProfiles = with userProfiles;
      lib.genAttrs profileNames userImport // {
        services = lib.genAttrs serviceNames serviceImport;
        base = { imports = [ ./nixos.nix (userImport "base") ]; };
      };
  in
  userProfiles;
in { __functor = self: youkoUser; isModule = false; }
