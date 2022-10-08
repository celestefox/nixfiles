{ pkgs, ...}: {
  home.packages = /*mkIf (config.networking.hostname != "okami")*/ (with pkgs; [ gnome.seahorse ]);
}