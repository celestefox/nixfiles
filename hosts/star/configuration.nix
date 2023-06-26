{ config, pkgs, lib, modulesPath, users, profiles, services, ... }@args: with lib; let
  #res = tf.resources;
in
{
  # Imports
  imports = with meta; [
    users.celeste.nixos
    services.nginx
    services.site
    services.wgnet_hub # previously services.wg
    services.knot-resolver
    services.gitea
    # TODO: revisit this?
    #(modulesPath + "/virtualisation/digital-ocean-config.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Terraform

/*
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

    # dns records
    #providers.gandi.inputs.key = tf.variables.gandi_key.ref; # services/nginx
    variables.cloudflare_token = { type = "string"; sensitive = true; };
    providers.cloudflare.inputs.api_token = tf.variables.cloudflare_token.ref;
    dns.zones."foxgirl.tech." = { provider = "cloudflare"; cloudflare.id = "1d0e0445e027d14092d3f7ef772a4740"; };
    dns.records = let
      hn = config.networking.hostName;
      def = { enable = true; zone = "foxgirl.tech."; domain = hn; };
    in
    {
      "${hn}.foxgirl.tech_4" = def // { a.address = res.${hn}.refAttr "ipv4_address"; };
      "${hn}.foxgirl.tech_6" = def // { aaaa.address = res.${hn}.refAttr "ipv6_address"; };
      "foxgirl.tech" = def // { domain = "@"; cname.target = "${hn}.foxgirl.tech."; };
    };
  };
  */

  # Home manager
  home-manager = {
    users.celeste = { imports = [ users.celeste.hm /*users.celeste.gui*/ ]; };
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
    domain = "foxgirl.tech";
    useDHCP = false;
    interfaces.ens3 = {
      useDHCP = true; # For v4
      ipv6.addresses = [{
        address = "2a01:4f9:c010:2cf9::1";
        prefixLength = 64;
      }];
      /* TODO: configure this automatically again?
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
    nameservers = [ "1.1.1.1" "1.0.0.1" ];

    # firewall
    firewall = {
      enable = true;
    };
  };

  # State

  system.stateVersion = "22.05";
}
