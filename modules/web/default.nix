{ config, lib, pkgs, ... }:

let cfg = config.bds.web;

in {
  imports = [ ./cgit.nix ];

  options.bds.web = {
    enable = lib.mkEnableOption "Enable Hosted Web Services";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.nginx = {
      enable = true;
      package = pkgs.nginxMainline;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      virtualHosts = let template = {
        enableACME = true;
        forceSSL = true;
      }; in {
        "breakds.org" = template // {
          root = "/home/delegator/www/breakds.org";
          locations."/" = {
            extraConfig = ''
              try_files $uri @storage;
              # kill cache
              add_header Last-Modified $date_gmt;
              add_header Cache-Control 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
              if_modified_since off;
              expires off;
              etag off;
            '';
          };
          locations."@storage" = {
            root = "/home/delegator/www/breakds.org";
            extraConfig = ''
              autoindex on;
            '';
          };
        };
        "files.breakds.org" = template // {
          locations."/".proxyPass = "http://localhost:5962";
        };
        "git.breakds.org" = template // {
          locations."/".proxyPass = "http://localhost:5964";
        };
      };
    };
  };
}
