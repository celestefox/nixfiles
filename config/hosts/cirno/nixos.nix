{ meta, config, tf, pkgs, lib, modulesPath, ... }: with lib; let
  res = tf.resources;
in

  /*
    SETUP Please edit this scaffold! This should not be used directly and is effectively a mix of the usual:
    * hardware-configuration.nix
    * configuration.nix
  */

{
  # Imports

  imports = with meta; [
    users.youko.base
    # TODO: revisit this?
    #(modulesPath + "/virtualisation/digital-ocean-config.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Terraform

  deploy.tf = {
    /*
      resources.cirno = {
      provider = "digitalocean";
      type = "droplet";
      inputs = {
      image = "ubuntu-20-04-x64";
      name = "cirno";
      region = "ams3";
      size = "s-1vcpu-2gb";
      ssh_keys = [ 30535593 30535589 ];
      };
      connection = {
      port = head config.services.openssh.ports;
      host = tf.lib.tf.terraformSelf "ipv4_address";
      };
      };
      variables.do_token = {
      type = "string";
      sensitive = true;
      #shellCo
      };
      providers.digitalocean.inputs.token = tf.variables.do_token.ref;
    */
    # Token for Hetzner Cloud
    variables.hcloud_token = {
      type = "string";
      sensitive = true;
    };

    # Provider config
    # XXX: Move these to common somewhere?
    providers.hcloud.inputs.token = tf.variables.hcloud_token.ref;

    # Create the server
    resources.cirno = {
      provider = "hcloud";
      type = "server";
      # Initial server config
      inputs = {
        name = "cirno";
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
    deploy.systems.cirno.lustrate = {
      enable = true;
      connection = tf.resources."${config.networking.hostName}".connection.set // {
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

  #swapDevices = [{ device = "/dev/disk/by-uuid/2223e305-79c9-45b3-90d7-560dcc45775a"; }];

  # Bootloader

  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  boot = {
    growPartition = true;
    # TODO: useful for Hetzner?
    #kernelParams = [ "console=ttyS0" "panic=1" "boot.panic_on_fail" ];
    #initrd.kernelModules = [ "virtio_scsi" ];
    #kernelModules = [ "virtio_pci" "virtio_net" ];
    # From kat's hcloud-imperative
    initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sd_mod" "sr_mod" ];
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
    hostName = "cirno";
    useDHCP = false;
    /*interfaces.enp1s0.ipv4.addresses = mkIf (tf.state.resources ? ${tf.resources.${config.networking.hostName}.out.reference}) (singleton {
      address = (tf.resources.${config.networking.hostName}.importAttr "ipv4_address");
      prefixLength = 24;
      });*/
    interfaces.ens3 = {
      useDHCP = true; # For v4
      ipv6.addresses = mkIf (tf.state.resources ? ${tf.resources.${config.networking.hostName}.out.reference}) [{
        address =
          (tf.resources.${config.networking.hostName}.importAttr "ipv6_address");
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enss3";
    };
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  /*network = {
    tf.enable = true;
    addresses.public.enable = true;
    addresses = {
    public = {
    nixos = {
    ipv4.address = "192.168.1.32";
    };
    };
    };
    yggdrasil = {
    enable = false;
    # SETUP replace
    pubkey = "0000000000000000000000000000000000000000000000000000000000000001";
    listen.enable = false;
    };
    };*/

  # Firewall

  network.firewall = {
    public = {
      interfaces = singleton "ens3";
      #tcp.ports = [ 9981 9982 ];
    };
  };

  # State

  system.stateVersion = "21.11";
}
