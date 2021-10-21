{ sources, ... }:

{
  imports = [
    (import (sources.arcexprs + "/modules")).home-manager
    ./firewall.nix
    ./deploy.nix
    ./secrets.nix
    ./theme.nix
    (sources.tf-nix + "/modules/home/secrets.nix")
  ];
}
