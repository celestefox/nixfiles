{ config, lib, pkgs, ... }:

{
  secrets = {
    root = "/var/lib/foxgirl/secrets";
    persistentRoot = "/var/lib/foxgirl/secrets";
    external = true;
  };
}
