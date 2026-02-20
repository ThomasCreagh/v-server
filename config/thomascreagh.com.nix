{ config, lib, pkgs, ... }:

{
  systemd.services.thomascreagh-update = {
    description = "Update thomascreagh.com site";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    environment = {
      DIR = "/var/www/thomascreagh.com";
    };
    path = with pkgs; [
      git
      openssh
    ];
    script = ''
      set -eu

      pushd $DIR >> /dev/null
      echo "Pull starting"
      git pull
      echo "Pull complete"
      popd >> /dev/null
    '';
  };

  systemd.timers.thomascreagh-update= {
    description = "Run update on website every 30 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "30m";
      Unit = "thomascreagh-update.service";
    };
  };
}
