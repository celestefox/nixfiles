{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  ## Rofi
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
      rofi-file-browser
      # These three are scripts, not plugins
      #rofi-menugen
      #rofi-power-menu
      #rofi-systemd
    ];
    extraConfig = {
      ssh-command = "{terminal} {ssh-client} {host} [-p {port}]";
      ssh-client = "kitty +kitten ssh";
      run-shell-command = "{terminal} {cmd}";
      modes = "drun,run,ssh,window,combi";
      show-icons = true;
    };
  };
  home.packages = [
    (pkgs.writeShellApplication {
      name = "pmenu";
      runtimeInputs = [config.programs.rofi.finalPackage pkgs.rofi-power-menu];
      text = ''
        rofi -show power -modi "power:rofi-power-menu"
      '';
    })
  ];
}
