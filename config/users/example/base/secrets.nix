{ config, lib, ... }:

{
  secrets = {
    persistentRoot = config.xdg.cacheHome + "/secrets";
    external = true;
  };
}

