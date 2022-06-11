{ config, lib, pkgs, ... }: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        dmenu = "${config.programs.rofi.finalPackage}/bin/rofi";
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
      };
    };
  };
}
