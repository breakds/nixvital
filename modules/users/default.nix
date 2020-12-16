{ config, lib, pkgs, ... }:

let cfg = config.vital;

in {

  options.vital = with lib; {
    mainUser = mkOption {
      type = types.str;
      default = "breakds";
      example = "breakds";
      description = "The main user name with uid = 1000";
    };
  };

  config = {
    users = {
      extraUsers = {
        "${cfg.mainUser}" = {
          isNormalUser = true;
          initialHashedPassword = lib.mkDefault "$5$o2c1SrFVg1xK570h$EO3uklJz1y3SbIPJ5zBUdG6ZYNFKoui3EYa5CX/9j0A";
	        home = "/home/${cfg.mainUser}";
          uid = 1000;
          # TODO(breakds): Make this configurable.
	        description = "${cfg.mainUser}";
          extraGroups = [
	          "${cfg.mainUser}"
	          "wheel"  # Enable `sudo`
	          "networkmanager"
	          "dialout"  # Access /dev/ttyUSB* devices
	          "uucp"  # Access /ev/ttyS... RS-232 serial ports and devices.
	          "audio"
	          "plugdev"  # Allow members to mount/umount removable devices via pmount.
            "gitea"
	          "lxd"
	          "docker"
            "nginx"
            "samba"
          ];
          openssh.authorizedKeys.keyFiles = lib.mkIf (cfg.mainUser == "breakds") [ ../keys/breakds_samaritan.pub ];
        };

        fcgi = {
          group = "fcgi";
	        extraGroups = [ "fcgi" "git" ];
	        uid = 500;
        };

        nginx = {
          group = "nginx";
          extraGroups = [ "nginx" ];
          uid = 60;
        };

        git = {
          isNormalUser = true;
          group = "git";
          extraGroups = [ "git" "fcgi" "gitea" ];
          uid = 510;
          home = "/home/git";
          description = "User for git server.";
        };
      };

      extraGroups = {
        "${cfg.mainUser}" = { gid = 1000; members = [ "${cfg.mainUser}" ]; };
        fcgi = { gid = 500; members = [ "fcgi" ]; };
        plugdev = { gid = 501; };
        nginx = { gid = 60; members = [ "nginx" ]; };
        git = { gid = 510; members = [ "${cfg.mainUser}" "git" "fcgi" ]; };
        localshare = { gid = 758; members = [ "${cfg.mainUser}" ]; };
      };
    };
  };
}
