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
      obs-shaderfilter
      obs-teleport
      obs-vkcapture
      obs-websocket
      obs-transition-table
      obs-backgroundremoval
      obs-tuna
      input-overlay
    ];
  };
}
