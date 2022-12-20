{ lib, ... }: with lib; {
  # WSL config
  wsl = {
    enable = true;
    wslConf = { automount.root = "/mnt"; };
    defaultUser = "celeste";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
    docker-desktop.enable = true;
  };

  # Not on WSL
  services.pcscd.enable = mkForce false;
}
