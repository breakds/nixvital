{ config, pkgs, lib, ... }:

let cfg = config.vital.code-server;

in {
  options.vital.code-server = with lib; {
    enable = lib.mkEnableOption "Enable this to start a visual studio code server.";
    port = lib.mkOption {
      type = lib.types.port;
      description = "The port on which vs code is served.";
      default = 5902;
      example = 5902;
    };
    domain = lib.mkOption {
      type = lib.types.str;
      description = "The domain to the code server.";
      default = "code.breakds.org";
      example = "code.breakds.org";
    };
  };
  
  config = lib.mkIf cfg.enable {
    systemd.services.code-server = {
      description = "Visual Studio Code Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      

      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.code-server}/bin/code-server --port ${toString cfg.port}
        '';
        Restart = "always";
      };
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
