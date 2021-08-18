{ config, pkgs, lib, ... }:

{
  users.users.example = {
    uid = 1000;
    isNormalUser = true;
    # SETUP Add this
    openssh.authorizedKeys.keys = [
    ];
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "systemd-journal" "plugdev" ];
    # SETUP Change this
    hashedPassword =
      "$6$i28yOXoo$/WokLdKds5ZHtJHcuyGrH2WaDQQk/2Pj0xRGLgS8UcmY2oMv3fw2j/85PRpsJJwCB2GBRYRK5LlvdTleHd3mB.";
    };

    systemd.tmpfiles.rules = [
      "f /var/lib/systemd/linger/example"
    ];
}
