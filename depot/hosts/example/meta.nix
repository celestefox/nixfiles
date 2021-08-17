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
      imports = lib.hostImport {
        hostName = "example";
        inherit profiles root;
      };
    };
  };
}
