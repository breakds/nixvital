{ pkgs, lib, ... }:

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
      default = "";
      example = "/home/breakds/filerun/db";
    };
    port = lib.mkOption {
      type = lib.types.port;
      description = "The port (on host) that filerun will be served on.";
      default = defaultPort;
    };
    volumes = mkOption {
      type = with types; listOf str;
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
      example = literalExample ''
        [
          "/path/on/host/a:/MyDataDir",
          "/path/on/host/b:/MyDataForAnotherUser",
        ]
      '';
    };
  };

  config = {
  };
}
