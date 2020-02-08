# This separate delegator user configuration will be activated (imported) for
# services that runs under the user "delegator", for example many web servers.
#
# The reason being that delegator is merely a delegation owner, to free the risk
# of exposing the main user.


{ config, lib, pkgs, ... }:

{
  users = {
    extraUsers.delegator = {
      isNormalUser = true;
      group = "delegator";
      createHome = true;
      uid = 600;
      home = "/home/delegator";
      extraGroups = [ "delegator" ];
    };

    extraGroups.delegator = {
      gid = 600;
      members = [ "delegator" "${config.vital.mainUser}" ];
    };
    
    # The main user should be in the delegator group.
    extraUsers."${config.vital.mainUser}".extraGroups = [ "delegator" ];
  };
}
