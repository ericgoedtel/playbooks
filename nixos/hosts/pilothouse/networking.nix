_: {
  networking = {
    hostName = "pilothouse";
    networkmanager.enable = false;
    useDHCP = false;
  };

  systemd = {
    network = {
      enable = true;
      netdevs = {
        "20-guests" = {
          netdevConfig = {
            Kind = "bridge";
            Name = "guests";
          };
        };
      };
      networks = {
        "10-eno1" = {
          # management interface
          matchConfig.MACAddress = "c8:f7:50:f8:b3:83";
          networkConfig = {
            Address = "192.168.99.253/24";
            Gateway = "192.168.99.1";
            DNS = "192.168.99.1";
          };
          linkConfig.RequiredForOnline = "routable";
        };
        "10-enp2s0f0" = {
          # mirroring port
          matchConfig.MACAddress = "a0:36:9f:91:18:d4";
          # Just bring it up, no IP configuration by default for a capture port
          linkConfig.RequiredForOnline = "no";
        };
        "10-enp2s0f1" = {
          # bridged port for guests
          matchConfig.MACAddress = "a0:36:9f:91:18:d5";
          networkConfig.Bridge = "guests";
          linkConfig.RequiredForOnline = "no";
        };
        "20-guests" = {
          matchConfig.Name = "guests";
          # TODO: I think we should be letting guests request DHCP addresses to the gateway.
          # networkConfig.DHCP = "yes";
          linkConfig.RequiredForOnline = "no";
        };
      };
    };
  };
}
