{ config, pkgs, lib, ... }:

let cfg = config.vital.experimental.nix-deployment;

    producer = pkgs.callPackage ./producer.nix {};
    reducer = pkgs.callPackage ./reducer.nix {};

in {
  options.vital.experimental.nix-deployment = {
    enable = lib.mkEnableOption "Enable the nix-deployment service.";

    rosMasterPort = lib.mkOption {
      type = lib.types.port;
      description = "The port at which ros master is running.";
      default = 11311;
    };

    reduceMethod = lib.mkOption {
      type = lib.types.enum [ "ADD" "MULTIPLY" ];
      default = "ADD";
      description = "The method on how to combine the left and right values.";
    };
  };
    
  config = lib.mkIf (cfg.enable) {
    # TODO(breakds): Make roscore part of this too.
    
    systemd.services.experimental-toy-ros-producer-left = {
      description = "Run producer as a systemd service (left).";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${producer}/bin/producer --channel /exp/left --name left";
        # Restart = "always";
      };
      environment = {
        "ROS_MASTER_URI" = "http://localhost:${toString cfg.rosMasterPort}";
      };
    };

    systemd.services.experimental-toy-ros-producer-right = {
      description = "Run producer as a systemd service (right).";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${producer}/bin/producer --channel /exp/right --name right";
        # Restart = "always";
      };
      
      environment = {
        "ROS_MASTER_URI" = "http://localhost:${toString cfg.rosMasterPort}";
      };
    };

    systemd.services.experimental-toy-ros-reducer = {
      description = "Run reducer as a systemd service.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${reducer}/bin/reducer --method ${cfg.reduceMethod}";
        # Restart = "always";
      };
      
      environment = {
        "ROS_MASTER_URI" = "http://localhost:${toString cfg.rosMasterPort}";
      };
    };
    
    
  };
}
