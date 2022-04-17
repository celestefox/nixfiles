{ config, lib, pkgs, tf, ... }: with lib;

{
  # Secrets for ACME
  deploy.tf.variables.gandi_key = {
    # TODO: replace w/ kw.secrets once practical
    # (practical means a secrets storage w/ a command is setup)
    type = "string";
    sensitive = true;
  };

  secrets.files.acme_creds = {
    text = ''
      GANDIV5_API_KEY='${tf.variables.gandi_key.ref}'
    '';
  };

  /*network.firewall = {
    public.tcp.ports = [ 443 80 ];
    private.tcp.ports = [ 443 80 ];
  };*/
  networking.firewall.allowedTCPPorts = [ 443 80 ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    # No certs right now!
    #recommendedTlsSettings = true;
    clientMaxBodySize = "512m";
  };

  security.acme = {
    defaults.email = "youko@chakat.space";
    acceptTerms = true;
  };
}
