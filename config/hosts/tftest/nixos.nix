{ meta, config, pkgs, lib, modulesPath, ... }:

with lib;

/*
SETUP Please edit this scaffold! This should not be used directly and is effectively a mix of the usual:
* hardware-configuration.nix
* configuration.nix
*/

{
  # Imports

  imports = with meta; [
    profiles.gui
    users.youko.gui
    users.youko.sway
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # File Systems and Swap

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/0fa44747-c2c2-4481-92da-dc7b183a9b4d";
      fsType = "ext4";
      autoResize = true;
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/FA05-FE9E";
      fsType = "vfat";
    };
  };

  #swapDevices = [{ device = "/dev/disk/by-uuid/60b00b41-57be-4d11-aa82-8829d4cb3832"; }];

  # Bootloader

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hardware

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];

  # Networking

  networking = {
    hostId = "9f89b327";
    hostName = "tftest";
    useDHCP = false;
    interfaces.enp1s0.ipv4.addresses = singleton {
      inherit (config.network.addresses.private.ipv4) address;
      prefixLength = 24;
    };
    defaultGateway = "192.168.122.1";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  network = {
    addresses = {
      private = {
        ipv4.address = "192.168.122.55";
      };
    };
    yggdrasil = {
      enable = false;
      # SETUP replace
      pubkey = "0000000000000000000000000000000000000000000000000000000000000001";
      listen.enable = false;
    };
    privateGateway = "192.168.122.1";
  };

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
