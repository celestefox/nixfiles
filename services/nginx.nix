{
  lib,
  pkgs,
  root,
  ...
}: {
  # Secret for ACME
  age.secrets.cf_lego = {
    file = root + "/secrets/cf_lego.age";
    # no user/group should be needed, used as systemd EnvironmentFile
  };

  # firewall
  networking.firewall.allowedTCPPorts = [443 80];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    # from https://nixos.wiki/wiki/Nginx#Using_realIP_when_behind_CloudFlare_or_other_CDN
    # disadvantages: have to rebuild to find out about/apply updates
    # todo: improve it, then, maybe?
    commonHttpConfig = let
      realIpsFromList = lib.strings.concatMapStringsSep "\n" (x: "set_real_ip_from  ${x};");
      fileToList = x: lib.strings.splitString "\n" (builtins.readFile x);
      cfipv4 = fileToList (pkgs.fetchurl {
        url = "https://www.cloudflare.com/ips-v4";
        sha256 = "0ywy9sg7spafi3gm9q5wb59lbiq0swvf0q3iazl0maq1pj1nsb7h";
      });
      cfipv6 = fileToList (pkgs.fetchurl {
        url = "https://www.cloudflare.com/ips-v6";
        sha256 = "1ad09hijignj6zlqvdjxv7rjj8567z357zfavv201b9vx3ikk7cy";
      });
    in ''
      ${realIpsFromList cfipv4}
      ${realIpsFromList cfipv6}
      real_ip_header CF-Connecting-IP;
    '';
    appendHttpConfig = ''add_header X-Clacks-Overhead "GNU Terry Pratchett";'';
    clientMaxBodySize = "512m";
  };

  # acme (letsencrypt) settings
  security.acme = {
    defaults = {email = "celeste@foxgirl.tech";};
    acceptTerms = true;
  };
}
