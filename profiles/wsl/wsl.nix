{
  lib,
  pkgs,
  flake,
  ...
}:
with lib; {
  # WSL config
  wsl = {
    enable = true;
    wslConf = {automount.root = "/mnt";};
    defaultUser = "celeste";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
    docker-desktop.enable = true;

    #tarball.configPath = flake.outPath;
  };

  # weh
  environment.systemPackages = singleton (pkgs.runCommand "wslpath" {} ''
    mkdir -p $out/bin
    ln -s /init $out/bin/wslpath
  '');

  # Not on WSL
  services.pcscd.enable = mkForce false;
}
