{ config, lib, pkgs, ... }:

{
  services.stalwart = {
    enable = true;
    openFirewall = false;

    settings = {
      server = {
        hostname = "mail.0x74.net";
        tls = {
          enable = true;
          implicit = true;
        };
        listener = {
          smtp = {
            protocol = "smtp";
            bind = "[::]:25";
          };
          submissions = {
            bind = "[::]:465";
            protocol = "smtp";
            tls.implicit = true;
          };
          submission = {
            bind = "[::]:587";
            protocol = "smtp";
          };
          imaps = {
            bind = "[::]:993";
            protocol = "imap";
            tls.implicit = true;
          };
          management = {
            bind = [ "127.0.0.1:8080" ];
            protocol = "http";
          };
        };
      };

      lookup.default = {
        hostname = "mail.0x74.net";
        domain = "0x74.net";
      };

      certificate."system" = {
        cert = "%{file:/var/lib/acme/mail.0x74.net/cert.pem}%";
        private-key = "%{file:/var/lib/acme/mail.0x74.net/key.pem}%";
      };

      server.tls.certificate = "system";

      storage = {
        data = "rocksdb";
        fts = "rocksdb";
        blob = "rocksdb";
        lookup = "rocksdb";
        directory = "internal";
      };

      store."rocksdb" = {
        type = "rocksdb";
        path = "/var/lib/stalwart-mail/data";
        compression = "lz4";
      };

      directory."internal" = {
        type = "internal";
        store = "rocksdb";
      };

      session.auth = {
        mechanisms = "[plain]";
        directory = "'internal'";
      };

      session.rcpt.directory = "'internal'";
      session.rcpt.catch-all = true;

      authentication.fallback-admin = {
        user = "admin";
        secret = "%{file:${config.age.secrets.stalwartAdmin.path}}%";
      };

      tracer."stdout" = {
        type = "stdout";
        level = "info";
        enable = true;
      };
    };
  };

  users.users.stalwart-mail.extraGroups = [ "acme" "nginx" ];

  security.acme.certs."mail.0x74.net" = {
    postRun = "systemctl restart stalwart.service";
  };

  age.secrets.stalwartAdmin = {
    file = ../secrets/stalwartAdmin.age;
    owner = "stalwart-mail";
    mode = "0400";
  };
}
