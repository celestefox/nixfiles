{ sources, ... }:

{
  imports = [
    (import (sources.arcexprs + "/modules")).home-manager
    (import (sources.katexprs + "/modules")).home
    ./deploy.nix
    ./secrets.nix
    (sources.tf-nix + "/modules/home/secrets.nix")
  ];
}
