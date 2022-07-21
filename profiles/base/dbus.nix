{ config, lib, pkgs, ... }: {
  services.dbus.packages = [ pkgs.gnome3.gnome-keyring pkgs.gcr ];
}