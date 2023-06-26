{ ... }: {
  # With home-manager being configured through nixos, the message from "suggest" doesn't get printed to screen
  # on successful switches, you have to check the journal of home-manager-$USERNAME.service
  # hence, use sd-switch to change services automatically, please
  systemd.user.startServices = "sd-switch";
}