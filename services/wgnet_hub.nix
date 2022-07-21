{ config, lib, pkgs, tf, flake, ... }: with lib; {
  # Secret for key
  age.secrets.star_wgnet_privkey = {
    file = flake.outPath + "/secrets/star_wgnet_privkey.age";
  };

  # Wireguard setup
  networking.wireguard = {
    enable = true;
    interfaces.wgnet = {
      # General settings
      privateKeyFile = config.age.secrets.star_wgnet_privkey.path;
      listenPort = 51820;

      # IPs
      ips = [
        "10.255.255.10/24" # v4 general
        "10.255.255.254/24" # v4 adtl
        "fe80::10/64" # v6 link local
        "2a01:4f9:c010:2cf9:f::10/80" #v6 general
        "2a01:4f9:c010:2cf9:f::ffff/80" #v6 adtl
      ];

      # Peers
      # TODO: Template?
      peers = [
        # amaterasu
        {
          allowedIPs = [
            "10.255.255.11/32"
            "fe80::11/128"
            "2a01:4f9:c010:2cf9:f::11/128"
          ];
          publicKey = "ig+dJAIs+WW7kqt3BEBqNqf/SBkz/CLk4XAPuJLpaEM=";
        }
        # issun
        {
          allowedIPs = [
            "10.255.255.12/32"
            "fe80::12/128"
            "2a01:4f9:c010:2cf9:f::12/128"
          ];
          publicKey = "+sJWF79o1ozZSvUKWUJBl37T/tWVIok+4GcLypieqgc=";
        }
        # shiro
        {
          allowedIPs = [
            "10.255.255.13/32"
            "fe80::13/128"
            "2a01:4f9:c010:2cf9:f::13/128"
          ];
          publicKey = "xdXkQE4hpabWWxSadRazO2K3jg2I6aZKjctuqtjEIHY=";
        }
      ];
    };
  };

  # sysctl for forwarding
  # security concern without adequate firewall!
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.default.forwarding" = true;
    "net.ipv6.conf.all.fowarding" = true;
  };

  # firewall rules
  networking.firewall = {
    #trustedInterfaces = [ "wgnet" ];
    # allow wg traffic through
    allowedUDPPorts = [ 51820 ];
    # NAT and other rules
    # TODO: hardcoded for the interface names on star
    extraCommands = ''
      echo "Custom commands running..."
      # Cleanup and create chains
      #iptables -F fw-interfaces 2> /dev/null || true
      #iptables -X fw-interfaces 2> /dev/null || true
      #iptables -F fw-open 2> /dev/null || true
      #iptables -X fw-open 2> /dev/null || true
      #iptables -N fw-interfaces
      #iptables -N fw-open

      # Basic NAT rules
      iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
      #iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
      ip46tables -A FORWARD -i wgnet -o ens3 -j ACCEPT
      #iptables -A FORWARD -j fw-interfaces
      #iptables -A FORWARD -j fw-open
      #iptables -P FORWARD DROP

      # Who to forward
      ip46tables -A FORWARD -i wgnet -j ACCEPT

      # Simpler forward setup for v6, no NAT needed
      #ip6tables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
      #ip6tables -A FORWARD -i wgnet -o ens3 -j ACCEPT
      #ip6tables -P FORWARD DROP

      # Done
      echo "Custom commands done"
    '';
  };
}
