{ lib, ... }: with lib; {
  # WSL config
  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "celeste";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };

  # Not on WSL
  services.pcscd.enable = mkForce false;
}