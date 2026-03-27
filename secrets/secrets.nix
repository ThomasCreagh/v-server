let
  vServer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhNZM28V6roYyube1Xs5CKUiuEPIgRxAXoEZLEadlZL root@nixos";
in {
  "secrets/stalwartAdmin.age".publicKeys = [ vServer ];
  "secrets/wireguard.age".publicKeys = [ vServer ];
  "secrets/coturn.age".publicKeys = [ vServer ];
}
