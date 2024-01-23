{
  lib,
  pkgs,
  ...
}: {
  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
    # TODO: qt4 kvantum removed, still in hm module 2023-09-15
    style.package = lib.mkForce (with pkgs; [libsForQt5.qtstyleplugin-kvantum qt6Packages.qtstyleplugin-kvantum]);
  };
}
