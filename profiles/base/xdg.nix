{
  lib,
  pkgs,
  ...
}: {
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-kde];
    # the setting this is all for, allows for a way to open a browser from steam-run
    xdgOpenUsePortal = true;
  };
  systemd.user.services = {
    "xdg-desktop-portal".serviceConfig = {
      # To see the environment variables the service will start with first
      #ExecStartPre = ["systemd-cat env"];
      Environment = [
        # gives you debug logs. not quite enough for my problem, but helpful
        #"G_MESSAGES_DEBUG=all"
        # TODO: i just stole this from shell env, there's gotta be a better way, but this works for now!!!
        "PATH=/run/wrappers/bin:/home/celeste/.nix-profile/bin:/etc/profiles/per-user/celeste/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/home/celeste/.local/bin:/home/celeste/bin"
      ];
    };
  };
}
