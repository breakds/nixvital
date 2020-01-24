{ config, lib, pkgs, ... }:

let cfg = config.vital.web;
    ports = (import ../../data/resources.nix).ports;
    

in {
  imports = [ ./cgit.nix ];

  options.vital.web = {
    enable = lib.mkEnableOption "Enable Hosted Web Services";
    serveHomePage = lib.mkEnableOption "Whether host web page.";
    serveFilerun = lib.mkEnableOption "Whether to host the filerun server.";
    serveHydra = lib.mkEnableOption "Whether to host hydra server.";
  };

  config = lib.mkIf cfg.enable {
    # Note that 8888 is allowed for Jupyter Lab
    networking.firewall.allowedTCPPorts = [ 80 443 8888 ];
    services.nginx = {
      enable = true;
      package = pkgs.nginxMainline;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      # TODO(breakds): Make this per virtual host.
      clientMaxBodySize = "100m";

      virtualHosts = let template = {
        enableACME = true;
        forceSSL = true;
      }; in {
        # The home page
        "www.breakds.org" = lib.mkIf cfg.serveHomePage (template // {
          root = "/home/delegator/www/breakds.org";
        });
        "files.breakds.org" = lib.mkIf cfg.serveFilerun (template // {
          locations."/".proxyPass = "http://localhost:${toString ports.filerun}";
        });
        "hydra.breakds.org" = lib.mkIf cfg.serveHydra (template // {
          locations."/".proxyPass = "http://localhost:${toString ports.hydra.master}";
          # The following commented out configuration are for the case when
          # hydra instance is running inside a container WITH PRIVATE NETWOORK.
          #
          # Without these extra config for ssl header and ssl name,
          # the ACME certificate will not be able to certify the IP
          # address here.
          #
          # locations."/".extraConfig = ''
          #   proxy_set_header Host  hydra.breakds.org;
          #   proxy_ssl_name         hydra.breakds.org;
          # '';
        });
        "${cfg.cgit.servedUrl}" = lib.mkIf cfg.cgit.enable (
          template // {
            locations."/".proxyPass = "http://localhost:${toString ports.cgit.web}";
          }
        );
      };
    };
  };
}
