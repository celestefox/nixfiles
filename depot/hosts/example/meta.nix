{ meta, profiles, root, config, lib, ... }: with lib; {
  config = {
    deploy.targets.example = {
      tf = {
        resources.example = {
          provider = "null";
          type = "resource";
          connection = {
            port = head meta.network.nodes.example.services.openssh.ports;
            host = meta.network.nodes.example.network.addresses.private.ipv4.address;
          };
        };
      };
    };
    network.nodes.example = {
      imports = filter builtins.pathExists singleton ./nixos.nix
      ++ (if builtins.Attrs profiles.base then profiles.base.imports else singleton profiles.base) ++ singleton {
        home-manager.users.example = {
          imports = filter builtins.pathExists singleton ./home.nix;
        };
      };
    };
  };
}
