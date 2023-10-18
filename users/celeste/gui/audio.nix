{pkgs, ...}: {
  home.packages = with pkgs; [
    pulseaudio
    pavucontrol
    patchage
    helvum
  ];
  services.easyeffects = {
    enable = true;
  };
}
