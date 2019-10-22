{ config, lib, pkgs, ... }:

{
  # Add arcanist for phabricator related stuff.
  environment.systemPackages = with pkgs; [
    arcanist
  ];

  # Mount NAS
  # //10.1.50.20/Public /media/nas cifs credentials=/home/breakds/.smbcredentials,iocharset=utf8,uid=1000 0 0
  # //10.1.50.20/80t /media/us_nas_80t cifs credentials=/home/breakds/.smbcredentials,iocharset=utf8,uid=1000 0 0
  # //10.18.50.20/80t /media/gz_nas_80t cifs credentials=/home/breakds/.gzsmbcredentials,iocharset=utf8,uid=1000 0 0
  # //10.18.50.20/Public /media/gz_nas_50t cifs credentials=/home/breakds/.gzsmbcredentials,iocharset=utf8,uid=1000 0 0
  #
  # TODO: Create list of options for all of them.
  fileSystems."/media/nas" = {
    device = "//10.1.50.20/Public";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split.
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      iocharset_opts = "iocharset=utf8";
      uid_opts = "uid=1000,gid=1000";
    in ["${automount_opts},credentials=/home/breakds/.ussmbcredentials,${iocharset_opts},${uid_opts}"];
  };
}
