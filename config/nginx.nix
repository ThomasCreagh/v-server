{ config, lib, pkgs, ... }:
let
  domain = "0x74.net";
  matrixDomain = "matrix.${domain}";
  clientConfig = {
    "m.homeserver".base_url = "https://${matrixDomain}";
    "m.identity_server" = {};
  };
  serverConfig = {
    "m.server" = "${matrixDomain}:443";
  };
  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    add_header X-Frame-Options "DENY" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self'; frame-ancestors 'none'; form-action 'self'; base-uri 'self';" always;
    return 200 '${builtins.toJSON data}';
  '';
in {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  
    virtualHosts = {
      "turn.0x74.net" = {
        forceSSL = true;
        enableACME = true;
      };
      ${matrixDomain} = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://192.168.26.7:8008";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $host;
            client_max_body_size 100M;
          '';
        };
      };
      "social.thomascreagh.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://192.168.26.7:55001";
          proxyWebsockets = true;
        };
      };
      "mail.0x74.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
        };
      };
      "jellyfin.0x74.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://192.168.26.7:8096";
          proxyWebsockets = true;
        };
      };
      "0x74.net" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.0x74.net" ];
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
        locations."/" = {
          root = "/var/www/0x74.net";
        };
        extraConfig = ''
          add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
          add_header X-Frame-Options "DENY" always;
          add_header X-Content-Type-Options "nosniff" always;
          add_header Referrer-Policy "strict-origin-when-cross-origin" always;
          add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self'; frame-ancestors 'none'; form-action 'self'; base-uri 'self';" always;
        '';
      };
      "thomascreagh.com" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.thomascreagh.com" ];
        locations."/" = {
          root = "/var/www/thomascreagh.com";
        };
        extraConfig = ''
          add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
          add_header X-Frame-Options "DENY" always;
          add_header X-Content-Type-Options "nosniff" always;
          add_header Referrer-Policy "strict-origin-when-cross-origin" always;
          add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self'; frame-ancestors 'none'; form-action 'self'; base-uri 'self';" always;
        '';
      };
      "monitor.0x74.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://192.168.26.7:3000";
          proxyWebsockets = true;
        };
      };
      "vault.0x74.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://192.168.26.7:8222";
          proxyWebsockets = true;
        };
      };
      "img.0x74.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://192.168.26.7:2283";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
      };
      "rad.0x74.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://192.168.26.7:5232";
          proxyWebsockets = true;
        };
      };
    };
  };
}
