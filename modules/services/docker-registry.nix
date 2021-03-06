{ config, lib, ... }:

let cfg = config.vital.docker-registry;
    resources = import ../../data/resources.nix;

in {
  config = {
    options.vital.docker-reigstry = {
      domain = lib.mkOption {
        type = lib.types.str;
        description = "The domain name on which the docker resgistry is served.";
        default = resources.domains.docker-registry;
        example = "docker.breakds.org";
      };

      port = lib.mkOption {
        type = lib.types.port;
        description = "The port on which the docker registry is served.";
        default = resources.ports.docker-registry;
        example = 5050;
      };
    };
    
    services.dockerRegistry = {
      enable = true;
      # Do not enable redis cache for simplicity.
      enableRedisCache = false;
      enableGarbageCollect = true;
      prot = cfg.port;
    };

    networking.firewall.allowedTCPPorts = [ config.services.dockerRegistry.port ];

    services.nginx.virtualHosts = lib.mkIf config.vital.web.enable {
      "${cfg.domain}" = {
        enableACME = cfg.useSSL;
        forceSSL = cfg.useSSL;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
    };

    vital.nixvital-reflection.show = [
      { key = "docker-registry"; val = "activated"; }
    ];
  };
}
    
