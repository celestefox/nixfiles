{pkgs, ...}: {
  home.packages = with pkgs; [
    pulseaudio
    pavucontrol
    patchage
    helvum
  ];
  services.easyeffects = {
    enable = true;
    package = pkgs.easyeffects.override {speexdsp = pkgs.speexdsp.overrideAttrs (_: {configureFlags = [];});};
  };
}
