{ config, lib, kw, meta, ... }: with lib; {
  config = {
    deploy.targets.tftest = {
      tf = {
        resources.tftest = {
          provider = "null";
          type = "resource";
          connection = {
            port = head meta.network.nodes.tftest.services.openssh.ports;
            host = meta.network.nodes.tftest.network.addresses.private.ipv4.address;
          };
        };
      };
    };
    network.nodes.tftest = {
      imports = kw.nodeImport "tftest";
    };
  };
}
