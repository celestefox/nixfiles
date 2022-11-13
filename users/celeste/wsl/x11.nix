{ lib, config, pkgs, ... }: with lib; let
in {
  programs.fish.shellInit = ''
  set __wsl_host_ip (${pkgs.iproute}/bin/ip route show default | sed -n 's/.*via \([^ ]\+\).*$/\1/p')
  set -x DISPLAY $__wsl_host_ip:0
  set -x PULSE_SERVER tcp:$__wsl_host_ip
  set -x LIBGL_ALWAYS_INDIRECT 1
  '';
}