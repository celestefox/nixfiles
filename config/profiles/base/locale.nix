{ config, pkgs, ... }:

{
  /* SETUP Change this */
  fonts.fonts = [
    pkgs.tamzen
  ];
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Denver";
  console = {
    packages = [ pkgs.tamzen ];
    #keyMap = "uk";
  };
}
