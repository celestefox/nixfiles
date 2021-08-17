{ meta, sources, lib, ... }:

{
  imports = with (import (sources.arcexprs + "/modules")).nixos; [ base16 base16-shared modprobe ]
  ++ (with (import (sources.katexprs + "/modules")).nixos; [ firewall nftables ])
  ++ [
    ./deploy.nix
    ./secrets.nix
    (sources.tf-nix + "/modules/nixos/secrets.nix")
    (sources.tf-nix + "/modules/nixos/secrets-users.nix")
    (sources.hexchen + "/modules/network/yggdrasil")
  ];

  options.hexchen.dns = lib.mkOption { };
  options.hexchen.deploy = lib.mkOption { };

  config = {
    _module.args.hosts = lib.mapAttrs (_: config: { inherit config; } ) meta.network.nodes;
  };
}
