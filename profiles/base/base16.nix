{ config, lib, ... }: {
  base16 = {
    inherit (config.home-manager.users.celeste.base16) defaultSchemeName defaultScheme schemes;
    console.enable = true;
  };
}
