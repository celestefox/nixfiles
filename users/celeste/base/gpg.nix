{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ pinentry.qt ];
  programs.gpg = {
    enable = true;
    scdaemonSettings.disable-ccid = true;
  };
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableSshSupport = true;
    pinentryFlavor = "qt";
    extraConfig = lib.mkMerge [
      "auto-expand-secmem 0x30000" # otherwise "gpg: public key decryption failed: Cannot allocate memory"
      "pinentry-timeout 30"
      "allow-loopback-pinentry"
      "no-allow-external-cache"
    ];
  };
}