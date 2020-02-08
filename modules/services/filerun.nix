{ config, pkgs, lib, ... }:

let cfg = config.vital.filerun;
    resources = (import ../../data/resources.nix);
    defaultPort = resources.ports.filerun;
    defaultDomain = resources.domains.filerun;

in {
  imports = [ ../users/delegator.nix ];

  options.vital.filerun = {
    enable = lib.mkEnableOption "Enable the filerun service.";
    dbPasswd = lib.mkOption {
      type = lib.types.str;
      description = "The password for the database.";
      default = "filerunpasswd";
      example = "filerunpasswd";
    };
    workDir = lib.mkOption {
      type = lib.types.str;
      description = ''
        The directory where file run operates. 

        This includes the following subdirectories:
          1. web - for filerun to generate the static html/php files
          2. db - MariaDB's operating directory
          3. Other directories that will be generated based on vital.filerun.userDataDirs
      '';
      default = "/home/${config.vital.mainUser}/filerun";
      example = "/home/${config.vital.mainUser}/filerun";
    };
    port = lib.mkOption {
      type = lib.types.port;
      description = "The port (on host) that filerun will be served on.";
      default = defaultPort;
    };
    extraUserData = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = ''
        List of extra user data directories under vital.filerun.workDir.
        TODO(breakds): Make this more complete.
      '';
      example = lib.literalExample ''
        [ "breakds-files" ]
      '';
    };
    domain = lib.mkOption {
      type = lib.types.str;
      description = "The domain to configure nginx for this service.";
      default = defaultDomain;
      example = "files.breakds.org";
    };
  };

  config = lib.mkIf cfg.enable (
    let dbPath = "${cfg.workDir}/db";
        dbContainerName = "filerun-db";
        # The filerun container will need to use the hostname to connect to
        # the databse. By convention:
        #
        # 1. Docker containers in the same network uses the container's
        #    name as the hostname to access each other.
        # 2. In NixOS the container's actual name will be docker-<name>.service
        # 3. Hence the composite hostname below.
        dbContainerHost = "docker-${dbContainerName}.service";
        bridgeNetworkName = "filerun_network";

        runner = {
          user = config.users.extraUsers.delegator;
          group = config.users.extraGroups.delegator;
        };

    in {
      # Note that both containers will be put in the same user defined
      # (bridge) network.
      
      # The database (MariaDB)
      docker-containers."${dbContainerName}" = {
        image = "mariadb:10.1";
        environment = {
          "MYSQL_ROOT_PASSWORD" = cfg.dbPasswd;
          "MYSQL_USER" = "filerun";
          "MYSQL_PASSWORD" = cfg.dbPasswd;
          "MYSQL_DATABASE" = "filerundb";
        };
        volumes = [ "${dbPath}:/var/lib/mysql" ];
        extraDockerOptions = [ "--network=${bridgeNetworkName}" ];
      };

      # The backend and web app (Filerun)
      docker-containers."filerun" = {
        image = "afian/filerun";
        environment = {
          "FR_DB_HOST" = "${dbContainerHost}";
          # This is the default port that mariadb runs at.
          "FR_DB_PORT" = "3306";
          "FR_DB_NAME" = "filerundb";
          "FR_DB_USER" = "filerun";
          "FR_DB_PASS" = cfg.dbPasswd;
          "APACHE_RUN_USER" = "${runner.user.name}";
          "APACHE_RUN_USER_ID" = "${toString runner.user.uid}";
          "APACHE_RUN_GROUP" = "${runner.group.name}";
          "APACHE_RUN_GROUP_ID" = "${toString runner.group.gid}";
        };
        ports = [ "${toString cfg.port}:80" ];
        volumes = [
          "${cfg.workDir}/web:/var/www/html"
          "${cfg.workDir}/user-files:/user-files"
        ] ++ lib.lists.map (x: "${cfg.workDir}/${x}:/${x}") cfg.extraUserData;
        extraDockerOptions = [ "--network=${bridgeNetworkName}" ];
      };

      # This is an one-shot systemd service to make sure that the
      # required network is there.
      systemd.services.init-filerun-network-and-files = {
        description = "Create the network bridge ${bridgeNetworkName} for filerun.";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        
        serviceConfig.Type = "oneshot";

        script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
                 in ''
                   # Put a true at the end to prevent getting non-zero return code, which will
                   # crash the whole service.
                   check=$(${dockercli} network ls | grep "${bridgeNetworkName}" || true)
                   if [ -z "$check" ]; then
                     ${dockercli} network create ${bridgeNetworkName}
                   else
                     echo "${bridgeNetworkName} already exists in docker"
                   fi
                 '';
      };

      # The nginx configuration to expose it if nginx is enabled.
      services.nginx.virtualHosts = lib.mkIf config.vital.web.enable {
        "${cfg.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = "http://localhost:${toString cfg.port}";
        };
      };
    });
}
