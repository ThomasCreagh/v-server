{ config, lib, pkgs, ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@0x74.net";
  };

  age.secrets.wireguard = {
    file = ../secrets/wireguard.age;
    owner = "root";
    mode = "0400";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 25 465 587 993 7777 ];
  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.nat = {
    enable = true;
    externalInterface = "enp1s0";
    internalInterfaces = [ "wg0" ];
    internalIPs = [ "192.168.26.0/24" ];
    forwardPorts = [
      { sourcePort = 7777; destination = "192.168.26.7:7777"; proto = "tcp"; }
    ];
  };

  networking.useNetworkd = true;

  systemd.network = {
    enable = true;
    networks."10-enp1s0" = {
      matchConfig.Name = "enp1s0";
      linkConfig.MTUBytes = "1400";
      networkConfig.DHCP = "yes";
      address = [
        "2a01:4f8:1c1a:5f50::1/64"
      ];
      gateway = [
        "fe80::1"
      ];
    };

    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      networkConfig = {
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
      address = [
        "fd31:bf08:57cb::1/64"
        "192.168.26.1/24"
      ];
    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };
      wireguardConfig = {
        ListenPort = 51820;
        PrivateKeyFile = "%{file:${config.age.secrets.wireguard.path}}%";
      };

      wireguardPeers = [
        {
          PublicKey = "1xJa2L6AcL2XcRY65J3rWMwRRWUZJBoSGtxe4SHrpXQ=";
          AllowedIPs = [
            "fd31:bf08:57cb::7/128"
            "192.168.26.7/32"
          ];
        }
      ];
    };
  };
}
