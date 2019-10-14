{ config, lib, pkgs, ... }:

{
  options.docker-containers = lib.mkIf config.virtualisation.docker.enable {
    "mariadb-filerun" = {
      image = "mariadb:10.1";
      environment = {
        MYSQL_ROOT_PASSWORD = "filerun-password";
        MYSQL_USER = "breakds";
        MYSQL_PASSWORD = "filerun-password";
        MYSQL_DATABASE = "filerun";
      };
      volumes = [
        "/home/breakds/filerun/db:/var/lib/mysql"
      ];
    };
  };
}
