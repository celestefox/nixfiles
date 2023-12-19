{pkgs, ...}: {
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
  home.packages = [
    (pkgs.writeShellApplication {
      name = "kdeconnect-mpv";
      runtimeInputs = [pkgs.xclip];
      text = ''
        /etc/profiles/per-user/celeste/bin/mpv --fs --fs-screen-name=DVI-D-0 "$(xclip -o -selection clipboard)"
      '';
    })
  ];
}
