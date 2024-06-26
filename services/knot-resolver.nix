{pkgs, ...}: {
  # Firewall - this looks scary; access is limited by listen addresses instead!
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
  # Use it properly locally...
  networking.resolvconf.useLocalResolver = false;
  networking.resolvconf.extraConfig = ''
    name_servers='10.255.255.10'
  '';
  services.kresd = {
    enable = true;
    # brings cqueues for watching files, amongst other things
    # TODO: this almost works again, this blocks deployment of star though still because
    # the hblock rpz is watched, that's the `true`
    #package = pkgs.knot-resolver.override {extraFeatures = true;};
    # Listening
    listenPlain = [
      "10.255.255.10:53"
      #"[2a01:4f9:c010:2cf9:f::10]:53"
    ];
    # Other config (Lua!)
    extraConfig = ''
      -- Cache
      cache.size = 100 * MB

      -- Modules
      modules.load('bogus_log')
      modules.load('hints > iterate')
      -- modules.load('rebinding < iterate')
      modules.load('stats')
      modules.load('policy > hints')
      modules.load('view < cache')

      -- Add rules for special-use and locally-served domains
      -- https://www.iana.org/assignments/special-use-domain-names/
      -- https://www.iana.org/assignments/locally-served-dns-zones/
      for _, rule in ipairs(policy.special_names) do
        policy.add(rule.cb)
      end

      -- Disable DNS-over-HTTPS in applications
      -- https://support.mozilla.org/en-US/kb/canary-domain-use-application-dnsnet/
      policy.add(policy.suffix(
        policy.DENY_MSG('This network is unsuitable for DNS-over-HTTPS'),
        {todname('use-application-dns.net.')}
      ))

      -- Resolve "*-dnsotls-ds.metric.gstatic.com" as it is necessary for DNS-over-TLS functionality on Android
      -- https://android.googlesource.com/platform/packages/modules/DnsResolver/+/bab3daa733894008bf917713f9a72a4ccbbd3b3a/DnsTlsTransport.cpp#150
      policy.add(policy.pattern(
        policy.ANSWER({
          [kres.type.A] = { rdata = kres.str2ip('127.0.0.1'), ttl = 300 },
            [kres.type.AAAA] = { rdata = kres.str2ip('::1'), ttl = 300 }
        }, true),
        '%w+%-dnsotls%-ds' .. todname('metric.gstatic.com.') .. '$'
      ))

      -- Domain to replace
      extraTrees = policy.todnames({
          'go.'
      })
      --- Graft it
      policy.add(policy.suffix(policy.FLAGS({'NO_CACHE', 'NO_EDNS'}), extraTrees))
      policy.add(policy.suffix(policy.ANSWER({
        [kres.type.A] = { rdata=kres.str2ip('10.255.255.10'), ttl = 300 },
        [kres.type.AAAA] = { rdata=kres.str2ip('2a01:4f9:c010:2cf9:f::10'), ttl=300 }
      }), extraTrees))

      -- Blacklist TLDs
      policy.add(policy.suffix(policy.DENY_MSG('foxgirl.tech blocks certain gTLDs to prevent name confusion'), policy.todnames({'exe.', 'zip.', 'mov.'})))

      -- General filtering, todo: probably bootstraps badly
      policy.add(policy.rpz(policy.DENY_MSG('domain blocked by foxgirl.tech'),
        '/var/lib/knot-resolver/rpz/hblock.rpz',
        true
      ))
    '';
  };

  systemd.services."knot-resolver-hblock" = {
    description = "fetch and process host files for knot";
    script = builtins.readFile ./knot-resolver-hostfetch.bash;
    path = with pkgs; [coreutils hblock];
    serviceConfig = {
      Type = "oneshot";
      User = "knot-resolver";
      #RuntimeDirectory = "knot-resolver-hblock";
      StateDirectory = "knot-resolver/rpz";
    };
  };

  systemd.timers."knot-resolver-hblock" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
  # TODO: adblocking, i was gonna do it separate but nah
}
