{ config, pkgs, lib, ... }:

let cfg = config.vital.filerun;
    resources = (import ../../data/resources.nix);
    defaultPort = resources.ports.filerun;

in {
  options.vital.filerun = {
    enable = lib.mkEnableOption "Enable the filerun service.";
    dbPasswd = lib.mkOption {
      type = lib.types.str;
      description = "The password for the database.";
      default = "filerunpasswd";
      example = "filerunpasswd";
    };
    dbPath = lib.mkOption {
      type = lib.types.str;
      description = ''
        Path to the MariaDB directory.
        It will be mapped to /var/lib/mysql in the mariadb container.
      '';
      default = "/home/breakds/filerun/db";
      example = "/home/breakds/filerun/db";
    };
    port = lib.mkOption {
      type = lib.types.port;
      description = "The port (on host) that filerun will be served on.";
      default = defaultPort;
    };
    volumes = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = ''
        List of volumes to be attached to the filerun container.

        If you have a directory attach to /MyDataDir in the container, your
        should be able to see and use "MyDataDir" through your filerun instance's
        web interface.
        
        If you are not familiar with docker's volume, please refer to the
        <link xlink:href="https://docs.docker.com/engine/reference/run/#volume-shared-filesystems">
        for details.
      '';
      example = lib.literalExample ''
        [
          "/path/on/host/a:/MyDataDir",
          "/path/on/host/b:/MyDataForAnotherUser",
        ]
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # The database (MariaDB)
    docker-containers."filerun-db" = {
      image = "mariadb:10.1";
      environment = {
        "MYSQL_ROOT_PASSWORD" = cfg.dbPasswd;
        "MYSQL_USER" = "filerun";
        "MYSQL_PASSWORD" = cfg.dbPasswd;
        "MYSQL_DATABASE" = "filerundb";
      };
      volumes = [ "${cfg.dbPath}:/var/lib/mysql" ];
      extraDockerOptions = [ "--network=filerun_network" ];
    };

    # The backend and web app (Filerun)
    docker-containers."filerun" = {
      image = "afian/filerun";
      environment = {
        "FR_DB_HOST" = "docker-filerun-db.service";
        "FR_DB_PORT" = "3306";
        "FR_DB_NAME" = "filerundb";
        "FR_DB_USER" = "filerun";
        "FR_DB_PASS" = cfg.dbPasswd;
        "APACHE_RUN_USER" = "www-data";
        "APACHE_RUN_USER_ID" = "33";
        "APACHE_RUN_GROUP" = "www-data";
        "APACHE_RUN_GROUP_ID" = "33";
      };
      ports = [ "${toString cfg.port}:80" ];
      volumes = cfg.volumes;
      extraDockerOptions = [ "--network=filerun_network" ];
    };

    # This is an one-shot systemd service to make sure that the
    # required network is there.
    systemd.services.init-filerun-docker-bridge = {
      description = "Create the network bridge filerun_network for filerun.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      
      serviceConfig.Type = "oneshot";

      script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in ''
        # Put a true at the end to prevent getting non-zero return code, which will
        # crash the whole service.
        check=$(${dockercli} network ls | grep "filerun_network" || true)
        if [ -z "$check" ]; then
          ${dockercli} network create filerun_network
        else
          echo "filerun_network already exists in docker"
        fi
      '';
    };
  };
}
