{ lib, config, root,  profiles, ... }: with lib; {
  deploy.targets.dummy.enable = false;
  network.nodes.dummy = {
    imports = filter builtins.pathExists singleton ./nixos.nix
    ++ (if builtins.Attrs profiles.base then profiles.base.imports else singleton profiles.base) ++ singleton {
      home-manager.users.example = {
        imports = filter builtins.pathExists singleton ./home.nix;
      };
    };
    networking = {
      hostName = "dummy";
    };
  };
}
