{ pkgs, config, lib, ... }:

let cfg = config.vital.nix-serve;
    resources = (import ../../data/resources.nix);
    defaultDomain = resources.domains.nix-serve;
    defaultPort = resources.ports.nix-serve;

in {
  options.vital.nix-serve = {
    port = lib.mkOption {
      type = lib.types.port;
      description = "The port on which gitea is served.";
      default = defaultPort;
      example = 5000;
    };
    domain = lib.mkOption {
      type = lib.types.str;
      description = "The domain name on which gitea is served.";
      default = defaultDomain;
      example = "git.breakds.org";
    };
  };

  config = let
    stateDir = "/var/lib/nix-serve";
    privateKeyPath = "${stateDir}/${cfg.domain}.private.key";
    publicKeyPath = "${stateDir}/${cfg.domain}.public.key";    
  in {
    system.activationScripts.maybe-generate-nix-serve-keys = {
      text = ''
        if [ ! -f ${privateKeyPath} ]; then
            mkdir -p ${stateDir}
            ${pkgs.nix}/bin/nix-store --generate-binary-cache-key ${cfg.domain} \
              ${privateKeyPath} \
              ${publicKeyPath}
            chown nix-serve:users -R ${stateDir}
            chmod 755 ${stateDir}
            chmod 600 ${privateKeyPath}
            chmod 600 ${publicKeyPath}
        fi
      '';
      deps = [];
    };

    services.nix-serve = {
      enable = true;
      port = cfg.port;
      secretKeyFile = privateKeyPath;
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.nginx.virtualHosts = lib.mkIf config.vital.web.enable {
      "${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
    };
  };
}
