{ config, lib, pkgs, ... }:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = false;

  networking.hostName = "v-server";
  networking.useDHCP = true;

  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";

  time.timeZone = "Europe/Amsterdam";

  environment = {
    systemPackages = with pkgs; [
      vim wget git wireguard-tools sqlite netcat dig gnupg pinentry-curses
    ];
  };

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIENbTFvT06FmDkvIoYiBsI7nD5fvDIIGD+Zkug55k6Hu 1mn8wx5y@3rktz5yu0ubrq9b6.org"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKUsMGTeX/YQVQfzfo6/+mSHfA/OxFlAoaZZ2ZucgXQ vps key"
  ];

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "admin@0x74.net";
      certs."mail.0x74.net" = {
        webroot = "/var/lib/acme/acme-challenge";
        postRun = "systemctl restart stalwart-mail.service";
      };
    };
  };

  system.stateVersion = "25.05";
}
