{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        smartcardSupport = true;
        pipewireSupport = true;
      };
      nativeMessagingHosts = builtins.attrValues {inherit (pkgs) ff2mpv tridactyl-native plasma-browser-integration;};
    };
  };
  home.sessionVariables.BROWSER = "firefox";
}
