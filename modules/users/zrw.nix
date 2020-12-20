{ config, lib, pkgs, ... }:

{
  users = {
    extraUsers.zrw = {
      isNormalUser = true;
      group = "zrw";
      createHome = true;
      uid = 1008;
      home = "/home/zrw";
      extraGroups = [ "zrw" "audio" ];
      openssh.authorizedKeys.keyFiles = [ ../keys/zrw.pub ];
    };

    extraGroups = {
      zrw = {
        gid = 1008;
        members = [ "zrw" ];
      };
      localshare.members = [ "zrw" ];
    };
  };
}
