{ lib, pkgs, ... }: with lib; {
  # SSH
  programs.ssh = {
    enable = true;
    # control setup
    controlMaster = "auto";
    # forwarding
    forwardAgent = true;
    # other general options, grr
    # not sure why extraOptionOverrides is attrsOf str and this is str, shrug
    extraConfig = ''
    AddKeysToAgent yes
    '';
    # Host configuration
    matchBlocks = {
      "cirno" = {
        hostname = "138.68.59.195";
        user = "youko";
      };
    };
  };
}