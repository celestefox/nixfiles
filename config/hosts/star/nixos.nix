{ meta, config, tf, pkgs, lib, modulesPath, ... }: with lib; let
  res = tf.resources;
in {
  # Imports
  imports = with meta; [
    users.youko.base
    services.nginx
    services.site
    services.wg
    services.knot-resolver
    # TODO: revisit this?
    #(modulesPath + "/virtualisation/digital-ocean-config.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Terraform

  deploy.tf = {
    # Token for Hetzner Cloud
    variables.hcloud_token = {
      type = "string";
      sensitive = true;
    };

    # Provider config
    # XXX: Move these to common somewhere?
    providers.hcloud.inputs.token = tf.variables.hcloud_token.ref;

    # Create the server
    resources.star = {
      provider = "hcloud";
      type = "server";
      # Initial server config
      inputs = {
        name = "star";
        image = "ubuntu-20.04";
        server_type = "cx21";
        ssh_keys = [ 4445444 4445445 ];
      };
      connection = {
        port = head config.services.openssh.ports;
        host = tf.lib.tf.terraformSelf "ipv4_address";
      };
    };

    # Lustrate the server
    deploy.systems.star.lustrate = {
      enable = true;
      connection = res."${config.networking.hostName}".connection.set // {
        # Initial image uses default SSH port, so replace it
        port = 22;
      };
    };
  };

  # File Systems and Swap

  fileSystems = {
    "/" = {
      device = "/dev/sda1";
      fsType = "ext4";
      autoResize = true;
    };
    /*"/boot" = {
      device = "/dev/sda15";
      fsType = "vfat";
      };*/
  };

  # Bootloader

  boot = {
    growPartition = true;
    # From kat's hcloud-imperative
    initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_net" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
    loader = {
      timeout = 0;
      grub = {
        device = "/dev/sda";
        version = 2;
        configurationLimit = mkForce 0;
      };
    };
  };

  # Hardware

  # Networking

  networking = {
    hostId = "e0450306";
    hostName = "star";
    useDHCP = false;
    interfaces.ens3 = {
      useDHCP = true; # For v4
      ipv6.addresses = mkIf (tf.state.enable) [{
        address =
          (tf.resources.${config.networking.hostName}.getAttr "ipv6_address");
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
    nameservers = [ "1.1.1.1" "1.0.0.1" ];

    # firewall
    firewall = {
      enable = true;
    };
  };

  # State

  system.stateVersion = "21.11";
}
