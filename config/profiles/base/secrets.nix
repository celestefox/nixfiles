{ config, lib, pkgs, ... }:

{
  secrets = {
    root = "/var/lib/youko/secrets";
    persistentRoot = "/var/lib/youko/secrets";
    external = true;
  };
}
