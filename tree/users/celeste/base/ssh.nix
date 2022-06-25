{ lib, ... }: with lib; let
  personalHost = {
    port = 62954;
    forwardAgent = true;
    forwardX11 = true;
    forwardX11Trusted = true;
    extraOptions.RemoteForward = "/run/user/1111/gnupg/S.gpg-agent /run/user/1111/gnupg/S.gpg-agent.extra";
  };
in
{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
    compression = true;
    matchBlocks = {
      "star" = personalHost // { hostname = "star.foxgirl.tech"; };
      "star.wg" = personalHost // { hostname = "10.255.255.10"; };
      # good for testing auth
      "github.com".user = "git";
    };
  };
}
