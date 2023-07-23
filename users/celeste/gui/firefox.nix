{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        smartcardSupport = true;
        enablePlasmaBrowserIntegration = true;
        enableTridactylNative = true;
        pipewireSupport = true;
      };
      extraNativeMessagingHosts = [pkgs.ff2mpv];
    };
  };
  home.sessionVariables.BROWSER = "firefox";
}
