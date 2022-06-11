{ config, lib, pkgs, meta, ... }:

{
  security.sudo.wheelNeedsPassword = lib.mkForce false;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  users.motd = ''
    [0m[1;35m${config.networking.hostName}[0m

  '';

  users.users.root = {
    shell = pkgs.fish;
    hashedPassword =
      "$6$GMQrixgscVvF$uRYgBqeoTXCml/koXj8SVM8V/UQuXrjZOQO3LslVtqkL1oFTzMLOQIW38t3eEOgZ8Wn98fxn1ybgpj2ifLKoa.";
    openssh.authorizedKeys.keys = with pkgs.lib;
      [] ++ (concatLists (mapAttrsToList
        (name: user:
          if elem "wheel" user.extraGroups then
            user.openssh.authorizedKeys.keys
          else
            [ ])
        config.users.users));
  };
}
