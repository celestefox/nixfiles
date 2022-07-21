{ config, pkgs, lib, ... }: with lib; {
  ## Rofi
  programs.rofi = {
    enable = true;
    font = "Fira Code Regular 12";
    terminal = "${pkgs.kitty}/bin/kitty";
    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
      rofi-file-browser
      rofi-menugen
      rofi-power-menu
      rofi-systemd
    ];
  };
}
