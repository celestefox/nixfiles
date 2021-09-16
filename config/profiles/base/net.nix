{ config, lib, ... }:

{
  networking.nftables.enable = lib.mkDefault true;
}
