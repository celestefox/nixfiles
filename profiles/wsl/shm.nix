{ lib, pkgs, ... }: with lib; {
  systemd.services.fixshm = {
    # This is all mostly from bottle-imp
    description = "Fix the WSL2 /dev/shm symlink to be the original mount";
    before = [
      "local-fs-pre.target"
      "procps.service" "syslog.service" "systemd-firstboot.service" "systemd-sysctl.service" "systemd-sysusers.service" "systemd-tmpfiles-clean.service" "systemd-tmpfiles-setup-dev.service" "systemd-tmpfiles-setup.service"
    ];
    unitConfig = {
      DefaultDependencies = false;
      ConditionPathExists = "/dev/shm";
      ConditionPathIsSymbolicLink = "/dev/shm";
      ConditionPathIsMountPoint = "/run/shm";
    };
    wantedBy = singleton "local-fs-pre.target";

    path = [ pkgs.util-linux ];

    # Remove the symlink, make a dir as mountpoint, move the mount, bindmount back
    script = ''
      rm /dev/shm
      mkdir /dev/shm
      mount --move /run/shm /dev/shm
      mount --bind /dev/shm /run/shm
    '';
    serviceConfig.Type = "oneshot";
  };
}