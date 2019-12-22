{ config, lib, pkgs, ... } :

{
  config = {
    services.samba = {
      enable = true;
      # There are only two options here.
      #   1. "user" - requires an username and a password.
      #   2. "shared" - requires a password for each share.
      securityType = "user";
      extraConfig = ''
        workgroup = WORKGROUP
        server string = kirkwood-samba
        netbios name = kirkwood-samba
        security = user
        #use sendfile = yes
        #max protocol = smb2
        # hosts allow = 192.168.86  localhost
        # hosts deny = 0.0.0.0/0
        # guest account = nobody
        # map to guest = bad user
      '';
      shares = {
        clips = {
          path = "/home/samba";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "guest only" = "yes";
          "create mask" = "0644";
          "directory mask" = "0765";
          # When files and directories are created, specify the user and
          # group for them.
          "force user" = "samba";
          "force group" = "samba";
        };
      };
    };
    networking.firewall.allowPing = true;
    networking.firewall.allowedTCPPorts = [ 445 139 ];
    networking.firewall.allowedUDPPorts = [ 137 138 ];
    
    users = {
      extraUsers = {
        samba = {
          isNormalUser = true;
          createHome = true;
          uid = 677;
          extraGroups = [ "samba" ];
        };
      };
      extraGroups = {
        samba = {
          gid = 677;
          members = [ "samba" "breakds" ];
        };
      };
    };
  };
}
