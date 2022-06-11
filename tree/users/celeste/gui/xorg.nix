{
  #xsession
  xsession = {
    enable = true;
    # auto numlock
    numlock.enable = true;
  };
  # Keyboard
  home.keyboard = {
    layout = "us,us";
    variant = ",dvp";
    options = [ "grp:alt_space_toggle" "grp_led:caps" "caps:none" "ctrl:nocaps" "lv3:switch" "compose:sclk" ];
  };
  # xcape
  services.xcape = {
    enable = true;
    mapExpression = {
      Control_L = "Escape";
    };
  };
  #picom compositor
  services.picom = {
    enable = true;
    blur = false;
  };
}
