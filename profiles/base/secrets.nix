{ lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ rage ragenix age-plugin-yubikey ];
}