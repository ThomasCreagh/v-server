{ config, lib, pkgs, ... }:
{
  services.coturn = {
    enable = true;
    lt-cred-mech = true;
    use-auth-secret = true;
    static-auth-secret-file = config.age.secrets.coturn.path;
    realm = "turn.0x74.net";
    relay-ips = [
      "91.98.237.217"
    ];
    no-tcp-relay = true;
    extraConfig = "
      cipher-list=\"HIGH\"
      no-loopback-peers
      no-multicast-peers
    ";
    secure-stun = true;
    cert = "/var/lib/acme/turn.0x74.net/fullchain.pem";
    pkey = "/var/lib/acme/turn.0x74.net/key.pem";
    min-port = 49152;
    max-port = 49999;
  };
  age.secrets.coturn = {
    file = ../secrets/coturn.age;
    owner = "turnserver";
    mode = "0400";
  };
}
