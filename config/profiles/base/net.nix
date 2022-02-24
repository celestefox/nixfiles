{ config, lib, ... }:

{
  networking.nftables.enable = lib.mkDefault false;
  networking.firewall.enable = lib.mkDefault true;
}
