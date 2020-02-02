{ config, lib, pkgs, ... }:

let cfg = config.vital.nixvital-reflection;
    defaultPort = (import ../../data/resources.nix).ports.nixvital-reflection;

in {
  options.vital.nixvital-reflection = {
    enable = lib.mkEnableOption ''
      Enables the reflection server for the nixvital configs.

      The reflection server serves a web page that lists the variable/value pairs of the current nixvital (NixOS) configuration.
    '';

    port = lib.mkOption {
      type = lib.types.port;
      description = "The port that serves nixvital reflection web page.";
      default = defaultPort;
    };

    show = with lib; mkOption {
      type = types.listOf (types.submodule {
        options = {
          key = mkOption { type = types.str; default = "UNSPECIFIED"; };
          val = mkOption { type = types.str; default = "NO VALUE"; };
        };
      });
      description = "A list of key:value string to show on the web page.";
      default = [
        { key = "system.stateVersion"; val = config.system.stateVersion; }
      ];
    };
  };

  config = lib.mkIf (cfg.enable) {
    systemd.services.nixvital-reflection = {
      description = "nixvital-reflection";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ "${pkgs.simple-reflection-server}/bin" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = let showList = lib.lists.map (x: "${x.key}:${x.val}") cfg.show;
        in ''
          ${pkgs.simple-reflection-server}/bin/simple-reflection-server \
            ${toString showList}
        '';
        Restart = "always";
      };

      environment = {
        "ROCKET_PORT" = "${toString cfg.port}";
      };
    };
  };
}
