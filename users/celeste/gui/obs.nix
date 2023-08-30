{
  lib,
  pkgs,
  ...
}:
with lib; {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      /*
      obs-streamfx
      */
      obs-vkcapture
      obs-websocket
    ];
  };
}
