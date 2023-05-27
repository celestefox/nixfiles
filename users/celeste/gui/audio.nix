{ pkgs, ... }: {
  home.packages = with pkgs; [
    pulseaudio
    pavucontrol
    patchage
    helvum
  ];
}