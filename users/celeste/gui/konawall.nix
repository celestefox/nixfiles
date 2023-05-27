{ config, lib, ... }: {
  services.konawall = {
    enable = true;
    interval = "5m";
  };
  home.packages = lib.singleton config.services.konawall.konashow;
}