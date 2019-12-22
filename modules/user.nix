{ config, lib, pkgs, ... }:

{
  users = {
    extraUsers = {
      breakds = {
        isNormalUser = true;
	      initialPassword = "breakds";
	      home = "/home/breakds";
        uid = 1000;
	      description = "Break Yang";
        extraGroups = [
	        "breakds"
	        "wheel"  # Enable `sudo`
	        "networkmanager"
	        "dialout"  # Access /dev/ttyUSB* devices
	        "uucp"  # Access /ev/ttyS... RS-232 serial ports and devices.
	        "audio"
	        "plugdev"  # Allow members to mount/umount removable devices via pmount.
	        "lxd"
	        "docker"
          "nginx"
          "filerun"
          "delegator"
          "samba"
	      ];
        useDefaultShell = true;
        openssh.authorizedKeys.keyFiles = [ ./keys/breakds_samaritan.pub ];
      };

      # The user delegator is used to serve content for web services.
      delegator = {
        group = "delegator";
        createHome = false;
        uid = 600;
        home = "/home/delegator";
        extraGroups = [ "delegator" ];
      };

      filerun = {
        isNormalUser = false;
        initialPassword = "filerunpasswd";
        uid = 33;
        extraGroups = [ "filerun" ];
      };

      fcgi = {
        group = "fcgi";
	      extraGroups = [ "delegator" "fcgi" "git" ];
	      uid = 500;
      };

      nginx = {
        group = "nginx";
        extraGroups = [ "delegator" "nginx" ];
        uid = 60;
      };

      git = {
        isNormalUser = true;
        group = "git";
        extraGroups = [ "git" "delegator" "fcgi" ];
        uid = 510;
        home = "/home/git";
        description = "User for git server.";
      };
    };

    extraGroups = {
      breakds = { gid = 1000; members = [ "breakds" ]; };
      fcgi = { gid = 500; members = [ "fcgi" ]; };
      filerun = { gid = 33; members = [ "breakds" "filerun" ]; };
      plugdev = { gid = 501; };
      delegator = { gid = 600; members = [ "delegator" "breakds" "nginx" "fcgi" ]; };
      nginx = { gid = 60; members = [ "nginx" ]; };
      git = { gid = 510; members = [ "breakds" "git" "fcgi" ]; };
    };
  };
}
