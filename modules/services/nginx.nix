{ config, lib, pkgs, ... }:

let cfg = config.vital.web;
    resources = (import ../../data/resources.nix);
    ports = resources.ports;
    domains = resources.domains;

in {
  options.vital.web = {
    enable = lib.mkEnableOption "Enable Nginx proxy for web services.";
    serveHydra = lib.mkEnableOption "Whether to host hydra server.";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
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
      };
    };
  };
}
