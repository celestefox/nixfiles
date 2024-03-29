{
  config,
  lib,
  pkgs,
  root,
  ...
}:
with lib; {
  # Secrets for ACME
  /*
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
  */

  # Secret for ACME
  age.secrets.gandi_key = {
    file = root + "/secrets/gandi_key.age";
  };

  # firewall
  networking.firewall.allowedTCPPorts = [443 80];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    appendHttpConfig = ''add_header X-Clacks-Overhead "GNU Terry Pratchett";'';
    clientMaxBodySize = "512m";
  };

  # acme (letsencrypt) settings
  security.acme = {
    defaults = {email = "celeste@foxgirl.tech";};
    acceptTerms = true;
  };
}
