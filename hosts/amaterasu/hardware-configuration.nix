{ config, lib, pkgs, ... }:

{
  # instead of import
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # kernelmews
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelParams = [ "nohibernate" ]; # no work w/ zfs
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
  ''; # zfs already has its own scheduler. without this my(@Artturin) computer froze for a second when i nix build something.

  # fs
  fileSystems = {
    # plain root still
    "/" = {
      device = "zroot/root/nixos";
      fsType = "zfs";
    };
    # and default home
    "/home" = {
      device = "zroot/home";
      fsType = "zfs";
    };
    /*
      # Only for structure rn
      "/persist" = {
      device = "zroot/safe/persist";
      fsType = "zfs";
      };
      # Persist for home
      "/persist/home" = {
      device = "zroot/safe/home";
      fsType = "zfs";
      };
      # The impermanent home
      "/home/celeste" = {
      device = "zroot/local/celeste";
      fsType = "zfs";
      };
    */
    # boot
    "/boot" = {
      device = "/dev/disk/by-uuid/F83F-3B29";
      fsType = "vfat";
    };
  };

  # The zfs impermanence magic
  /*
    boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r zroot/local/root@blank
    zfs rollback -r zroot/local/celeste@blank
    '';
  */

  swapDevices = [{ device = "/dev/disk/by-uuid/7575d2aa-e014-463d-83f0-3eda0487dbe2"; }];

  nix.settings.max-jobs = lib.mkDefault 12;
}
