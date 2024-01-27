{
  config,
  pkgs,
  hosts,
  users,
  profiles,
  services,
  lib,
  ...
}:
with lib; {
  imports = [
    # Include the results of the hardware scan.
    hosts.amaterasu.hardware-configuration
    hosts.amaterasu.ether
    users.celeste.nixos
    profiles.gui
    profiles.hardware.printing
    profiles.gaming
    services.iperf
  ];

  nixpkgs.config.allowUnfree = true;

  # heck!
  # boot.crashDump.enable = true;
  # # heck 3.0!!
  # boot.kernelPatches = [
  #   {
  #     name = "netconsole";
  #     patch = null;
  #     extraStructuredConfig = with lib.kernel; {
  #       NETCONSOLE = yes;
  #       #NETCONSOLE_DYNAMIC = yes;
  #     };
  #   }
  # ];

  # General host configuration
  networking.hostName = "amaterasu"; # Define your hostname.
  networking.hostId = "a7899ef0"; # Needed for zfs
  # Select internationalisation properties.
  i18n = {
    #consoleFont = "Lat2-Terminus16";
    #consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Denver";

  # More hardware stuff:

  # redist firmwares, yes
  hardware.enableRedistributableFirmware = true;
  boot.kernelParams = [
    "nohibernate" # no work w/ zfs
    "amd_pstate=passive" # give me frequency lowering please
    "amd_pstate.shared_mem=1"
    #"debug" # heck 2!
    #"ignore_loglevel" # electric mewwymew?
    #"netconsole=+@/,@10.255.254.13/d8:bb:c1:a7:dd:c5" # because kdump didn't work...
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.plymouth.enable = true;
  boot.supportedFilesystems = ["zfs" "ntfs"];
  boot.zfs.forceImportAll = false;
  boot.zfs.forceImportRoot = false;
  # Wifi driver and v4l2loopback for OBS
  boot.extraModulePackages = with config.boot.kernelPackages; [rtl88xxau-aircrack v4l2loopback];
  boot.kernelModules = ["v4l2loopback"]; # Load automatically
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 video_nr=9 card_label="obs"
  '';
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
  ''; # zfs already has its own scheduler. without this my(@Artturin) computer froze for a second when i nix build something.
  nix.settings.max-jobs = lib.mkDefault 12;
  powerManagement.cpuFreqGovernor = "ondemand";
  boot.initrd.kernelModules = ["amd_pstate"];

  # TODO: consider using this? Need to revisit wireless situation, maybe even WG too, tho...
  #networking.useNetworkd = true; # Experimental
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.interfaces = [
    #"wlp3s0f0u10"
    #"wlp3s0f0u1"
    "wlp43s0f3u3"
  ]; # Fixes the random failure on boot??? According to trace
  #networking.wireless.userControlled.enable = true; #... disables using /etc/wpa_supplicant.conf???

  #networking.interfaces.wlp3s0f0u1.useDHCP = true;

  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    /*
    wg1 = {
    ips = [ "fdd9:80f2:e3::bc19:57ea/32" ];
    peers = [
      {
        allowedIPs = [ "fdd9:80f2:e3::/48" ];
        endpoint = "78.47.203.115:51820";
        publicKey = "O/YKniD72Fo/VFc0Mlu6cMxheWHTTQL4wYARmWFBrEM=";
      }
    ];
    privateKeyFile = "/private/wg_privkey_comint";
    allowedIPsAsRoutes = true;
    };
    */
    # TODO: factor out into service/wgnet_client? maybe module instead?
    wgnet = {
      ips = [
        "10.255.255.11/32"
        "2a01:4f9:c010:2cf9:f::11/128"
      ];
      peers = [
        {
          allowedIPs = [
            "10.255.255.0/24"
            "2a01:4f9:c010:2cf9:f::/80"
          ];
          endpoint = "65.21.52.236:51820";
          publicKey = "7PYB2Sqh+P3XbsaJLGJgriZzUsg5vSspTNP3GLueJGs=";
        }
      ];
      privateKeyFile = "/private/wgnet_amaterasu.key";
      allowedIPsAsRoutes = true;
    };
  };

  networking.nameservers = ["1.1.1.1" "1.0.0.1"];

  networking.resolvconf = {
    enable = true;
    #useLocalResolver = true;
  };

  /*
     services.yggdrasil = {
    enable = true;
    configFile = "/private/yggdrasil.conf";
  };
  */

  # Final hacky bit of trying to get this to work?
  #networking.localCommands = ''
  #${pkgs.systemd}/bin/resolvectl dns vboxnet0 127.0.0.1:5353
  #'';

  #services.resolved = {
  #enable = true;
  #};

  services.avahi = {
    enable = true;
    ipv4 = true;
    ipv6 = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      domain = true;
      workstation = true;
      addresses = true;
      userServices = true;
    };
  };

  # For kde-connect
  networking.firewall = {
    checkReversePath = false; # Don't filter DHCP packets, according to nixops-libvirtd
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    wget
    vim
    # Vulkan?
    vulkan-headers
    vulkan-loader
    vulkan-tools
    vulkan-validation-layers
    # opencl
    clinfo
    # libvirt stuff
    virt-manager
    libguestfs
    # docker
    docker-compose #arion # arion's failing to build rn
    # icons
    gnome3.adwaita-icon-theme
    pam_u2f
  ];

  programs.git.enable = true;

  # synergy
  services.synergy.server = {
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # Android setup
  programs.adb.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;
  # Experimental replacement w/ PipeWire!
  security.rtkit.enable = true; # optional but recommended
  services.pipewire = {
    enable = true;
    # Alsa support
    alsa.enable = true;
    alsa.support32Bit = true;
    # Pulse
    pulse.enable = true;
    # JACK
    jack.enable = true;

    # Example session manager (default for now...)
    #media-session.enable = true;
    # Bluetooth improvements
    /*
    media-session.config.bluez-monitor.rules = [
    {
      # Matches all cards
      matches = [{ "device.name" = "~bluez_card.*"; }];
      actions = {
        "update-props" = {
          "bluez5.auto-connect" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          # mSBC is not expected to work on all combos
          #"bluez5.msbc-support" = true;
          # SBC-XQ is not expected to work on all headset + adapter combinations.
          "bluez5.sbc-xq-support" = true;
        };
      };
    }
    {
      matches = [
        # Matches all sources
        { "node.name" = "~bluez_input.*"; }
        # Matches all outputs
        { "node.name" = "~bluez_output.*"; }
      ];
      actions = {
        "update-props" = {
          "node.pause-on-idle" = false;
        };
        "node.pause-on-idle" = false;
      };
    }
    ];
    */
  };

  # Extra bluetooth config, for wireplumber now
  # I don't actually know if this will have the desired effect, it's from the wiki
  # But the mediasession version is bluez_card? I'll actually test eventually, but bluetooth is hard already
  environment.etc."wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
     bluez_monitor.properties = {
     	["bluez5.enable-sbc-xq"] = true,
      ["bluez5.enable-msbc"] = true,
      ["bluez5.enable-hw-volume"] = true,
      ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag a2dp_sink ]"
    }
  '';

  # The rest of bluetooth
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez5-experimental;
  };
  services.blueman.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.colord.enable = true;

  # TODO: i think this ends up as essentially a backup session? so, maybe worth to keep? maybe not?
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    #extraSessionCommands = "xrandr --output DVI-D-0 --primary --left-of HDMI-A-0";
  };

  # Enable 32bit OpenGL for, e.g. Wine programs
  hardware.opengl.driSupport32Bit = true;
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    #rocm-runtime-ext
  ];

  # ZFS services
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
  services.zfs.zed.settings = {
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = ["root"];
    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;
  };

  # Virtualization
  virtualisation.virtualbox.host = {
    #enable = true;
    #enableExtensionPack = true;
  };
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      ovmf.packages = [pkgs.OVMFFull.fd];
    };
  };
  virtualisation.docker = {
    # if you're gonna be a pain... the error seems to be this but i think i might try a Different container something instead too
    /*
    failed to start daemon: error initializing graphdriver: prior storage driver
    devicemapper is deprecated and will be removed in a future release; update
    the the daemon configuration and explicitly choose this storage driver to
    continue using it; visit https://docs.docker.com/go/storage-driver/ for more
    information
    */
    #enable = true;
  };

  # Steam controller support
  hardware.steam-hardware.enable = true;

  # solaar itself I don't have working, but the udev rules fix horizontal scrolling
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  hardware.keyboard.qmk.enable = true;

  # Misc programs...
  programs = {
    dconf.enable = true;
  };

  # pam u2f
  security.pam.u2f = {
    enable = true;
    #debug = true; # temp
    # control = "sufficient"; # default
  };

  home-manager.users.celeste = {imports = [users.celeste.hm users.celeste.gui];};

  users.mutableUsers = false;
  users.users = {
    root.hashedPassword = "$6$GMQrixgscVvF$uRYgBqeoTXCml/koXj8SVM8V/UQuXrjZOQO3LslVtqkL1oFTzMLOQIW38t3eEOgZ8Wn98fxn1ybgpj2ifLKoa.";
    # My old user
    glow = {
      isNormalUser = true;
      uid = 1000;
      description = "glow";
      #hashedPassword = "$6$GMQrixgscVvF$uRYgBqeoTXCml/koXj8SVM8V/UQuXrjZOQO3LslVtqkL1oFTzMLOQIW38t3eEOgZ8Wn98fxn1ybgpj2ifLKoa.";
      hashedPassword = "$6$WEqhv9jK3adTC2V2$5ZQHBDquIK8RZe94qTpjCiJNv.HuDbgteovJfFEl408ldKt.zDv0GzHwjh0q7NyxYYLPLp.e3EG1BxmP16cRi/";
      group = "glow";
      extraGroups = ["users" "wheel" "audio" "video" "vboxusers" "adbusers" "libvirtd" "docker" "wireshark"];
      shell = pkgs.fish;
    };
    #aaa
    celeste.uid = lib.mkForce 1111;
  };
  users.groups = {
    glow.gid = 1000;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.05"; # Did you read the comment?
}
