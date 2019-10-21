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
	      ];
        useDefaultShell = true;
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
    };

    extraGroups = {
      breakds = { gid = 1000; members = [ "breakds" ]; };
      fcgi = { gid = 500; };
      filerun = { gid = 33; members = [ "breakds" "filerun" ]; };
      plugdev = { gid = 501; };
      delegator = { gid = 600; members = [ "breakds" "delegator" ]; };
    };
  };
}
