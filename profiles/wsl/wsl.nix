{ ... }: {
  # WSL config
  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "youko";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };
}