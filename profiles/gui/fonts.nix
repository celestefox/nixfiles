{pkgs, ...}: {
  # Fonts!
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    liberation_ttf
    fira
    fira-code
    proggyfonts
    cm_unicode
    corefonts
    hack-font
    hasklig
    meslo-lg
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    source-code-pro
    source-han-code-jp
    unifont
    unifont_upper
    victor-mono
    # Garamond!
    eb-garamond
    # jp
    migu
    # fails?
    #ricty

    # Warning: big!
    # TODO: disabled to see if it helps emoji work
    #google-fonts
  ];
}
