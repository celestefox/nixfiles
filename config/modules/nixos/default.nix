{ meta, sources, lib, ... }:

{
  imports = [
    (import (sources.arcexprs + "/modules")).nixos
    #(import (sources.katexprs + "/modules")).nixos
    ./deploy.nix
    #./firewall.nix
    #./nftables.nix
    ./secrets.nix
    (sources.tf-nix + "/modules/nixos/secrets.nix")
    (sources.tf-nix + "/modules/nixos/secrets-users.nix")
    #(sources.hexchen + "/modules/network/yggdrasil")
  ];

  options.hexchen.dns = lib.mkOption { };
  options.hexchen.deploy = lib.mkOption { };

  config = {
    _module.args.hosts = lib.mapAttrs (_: config: { inherit config; } ) meta.network.nodes;
  };
}
