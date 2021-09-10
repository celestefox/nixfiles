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
      provider = "null";
      type = "resource";
      connection = {
        port = head config.services.openssh.ports;
        host = config.network.addresses.private.nixos.ipv4.address;
      };
      };*/
    /*resources.do_access = {
      provider = "digitalocean";
      type = "ssh_key";
      inputs = {
        name = "terraform/cirno access key";
        public_key = res.access_key.refAttr "public_key_openssh";
      };
    };*/
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
    deploy.systems.cirno.lustrate = {
      enable = true;
      connection = tf.resources."${config.networking.hostName}".connection.set // {
        port = 22;
      };
    };
  };

  # File Systems and Swap

  fileSystems = {
    "/" = {
      device = "/dev/vda1"; # For Ubuntu 20.04 image base
      fsType = "ext4";
      autoResize = true;
    };
    "/boot" = {
      device = "/dev/vda15"; # For Ubuntu 20.04 image base
      fsType = "vfat";
    };
  };

  #swapDevices = [{ device = "/dev/disk/by-uuid/2223e305-79c9-45b3-90d7-560dcc45775a"; }];

  # Bootloader

  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  # From digital-ocean-config.nix
  boot = {
    growPartition = true;
    kernelParams = [ "console=ttyS0" "panic=1" "boot.panic_on_fail" ];
    initrd.kernelModules = [ "virtio_scsi" ];
    kernelModules = [ "virtio_pci" "virtio_net" ];
    loader = {
      grub.device = "/dev/vda";
      timeout = 0;
      grub.configurationLimit = mkForce 0;
    };
  };

  # Hardware

  # Networking

  networking = {
    hostId = "e0450306";
    hostName = "cirno";
    useDHCP = false;
    interfaces.enp1s0.ipv4.addresses = mkIf (tf.state.resources ? ${tf.resources.${config.networking.hostName}.out.reference}) (singleton {
      address = (tf.resources.${config.networking.hostName}.importAttr "ipv4_address");
      prefixLength = 24;
    });
    defaultGateway = config.network.privateGateway;
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
      interfaces = singleton "enp1s0";
      #tcp.ports = [ 9981 9982 ];
    };
  };

  # State

  system.stateVersion = "21.11";
}
