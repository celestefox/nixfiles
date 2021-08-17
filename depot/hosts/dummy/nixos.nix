{ config, lib, pkgs, ... }:

with lib;

{
  boot.isContainer = true;
  networking = {
    useDHCP = false;
    hostName = "dummy";
  };
  users.users.root.hashedPassword = "";

  network.yggdrasil = {
    enable = false;
    listen.enable = false;
    # SETUP Put endpoints and pubkeys external to your configs here. Set the other things to true.
    listen.endpoints = [];
    extra.pubkeys = {
    };
  };
}
