{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neofetch
    smartmontools
    hddtemp
    lm_sensors
    cachix
    # Terminfo for some terminals, so even over SSH things work fine
    kitty.terminfo
    foot.terminfo
  ];
}
