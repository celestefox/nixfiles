{ config, lib, pkgs, ... }: with lib;
{
  services.openssh = {
    enable = true;
    ports = lib.mkDefault [ 62954 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = lib.mkDefault "prohibit-password";
      X11Forwarding = true;
      KexAlgorithms = [ "curve25519-sha256@libssh.org" ];
      LogLevel = "VERBOSE";
    };
    extraConfig = ''
      PubkeyAcceptedAlgorithms +ssh-rsa
      StreamLocalBindUnlink yes
    '';
  };
  programs.mosh.enable = true;
}
