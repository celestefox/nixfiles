{ meta, config, pkgs, lib, ... }:

with lib;

/*
SETUP Please edit this scaffold! This should not be used directly and is effectively a mix of the usual:
* hardware-configuration.nix
* configuration.nix
*/

{
  # Imports

  imports = with meta; [
    users.example.gui
  ];

  # File Systems and Swap

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/469a684b-eb8f-48a8-8f98-be58528312c4";
      fsType = "ext4";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/2223e305-79c9-45b3-90d7-560dcc45775a"; }];

  # Bootloader

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  # Hardware

  # Networking

  networking = {
    hostId = "9f89b327";
    useDHCP = false;
    interfaces.enp1s0.ipv4.addresses = singleton {
      inherit (config.network.addresses.private.ipv4) address;
      prefixLength = 24;
    };
    defaultGateway = config.network.privateGateway;
  };

/*  network = {
    addresses = {
      private = {
        ipv4.address = "192.168.1.32";
      };
    };
    yggdrasil = {
      enable = false;
      # SETUP replace
      pubkey = "0000000000000000000000000000000000000000000000000000000000000001";
      listen.enable = false;
    };
  }; */

  # Firewall

  network.firewall = {
    public = {
      interfaces = singleton "enp1s0";
      tcp.ports = [ 9981 9982 ];
    };
  };

  # State

  system.stateVersion = "21.11";
}
