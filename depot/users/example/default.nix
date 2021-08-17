let exampleUser = { lib }: let
  userImport = profile: { config, ... }: {
    config.home-manager.users.example = {
      imports = [
        (./. + "/${profile}")
      ];
    };
  }; serviceImport = profile: { config, ... }: {
    config.home-manager.users.example = {
      imports = [
        (./services + "/${profile}")
      ];
    };
  }; profileNames = lib.folderList ./. ["base" "services"];
  serviceNames = lib.folderList ./services [];
  userProfiles = with userProfiles;
  lib.genAttrs profileNames userImport // {
    services = lib.genAttrs serviceNames serviceImport;
    base = { imports = [ ./nixos.nix (userImport "base") ]; };
  }; in userProfiles;
in { __functor = self: exampleUser; isModule = false; }
