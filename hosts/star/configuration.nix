{
  lib,
  modulesPath,
  users,
  services,
  ...
}:
with lib; {
  # Imports
  imports = [
    users.celeste.nixos
    services.nginx
    services.site
    services.wgnet_hub # previously services.wg
    services.knot-resolver
    services.keycloak
    services.gitea
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Home manager
  home-manager = {
    users.celeste = {
      imports = [
        users.celeste.hm
        # users.celeste.gui
      ];
    };
  };

  # File Systems and Swap

  fileSystems = {
    "/" = {
      device = "/dev/sda1";
      fsType = "ext4";
      autoResize = true;
    };
    /*
    "/boot" = {
    device = "/dev/sda15";
    fsType = "vfat";
    };
    */
  };

  # Bootloader

  boot = {
    growPartition = true;
    # From kat's hcloud-imperative
    initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_net" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
    loader = {
      timeout = 0;
      grub = {
        device = "/dev/sda";
        configurationLimit = mkForce 0;
      };
    };
  };

  # Hardware

  # Networking

  networking = {
    hostId = "e0450306";
    hostName = "star";
    domain = "foxgirl.tech";
    useDHCP = false;
    interfaces.ens3 = {
      useDHCP = true; # For v4
      ipv6.addresses = [
        {
          address = "2a01:4f9:c010:2cf9::1";
          prefixLength = 64;
        }
      ];
      /*
         TODO: configure this automatically again?
      ipv6.addresses = mkIf (tf.state.enable) [{
        address =
          (tf.resources.${config.networking.hostName}.getAttr "ipv6_address");
        prefixLength = 64;
      }];
      */
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
    nameservers = ["1.1.1.1" "1.0.0.1"];

    # firewall
    firewall = {
      enable = true;
    };
  };

  # State

  system.stateVersion = "22.05";
}
