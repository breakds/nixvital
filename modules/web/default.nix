{ config, lib, pkgs, ... }:

let cfg = config.vital.web;

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
          locations."/".proxyPass = "http://localhost:5962";
        });
        "hydra.breakds.org" = lib.mkIf cfg.serveHydra (template // {
          locations."/".proxyPass = "http://192.168.88.27:8080";
        });
        "${cfg.cgit.servedUrl}" = lib.mkIf cfg.cgit.enable (
          template // {
            locations."/".proxyPass = "http://localhost:5964";
          }
        );
      };
    };
  };
}
