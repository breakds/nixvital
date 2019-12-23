{ config, lib, pkgs, ... } :

{
  config = {
    services.samba = {
      enable = true;
      # There are only two options here.
      #   1. "user" - requires an username and a password.
      #   2. "shared" - requires a password for each share.
      securityType = "user";
      # In the below configuration, hosts allow and hosts deny make
      # sure that the Samba server can only be accessed in the home network.
      extraConfig = ''
        workgroup = BYCQ
        server string = kirkwood-samba
        netbios name = kirkwood-samba
        security = user
        # use sendfile = yes
        # max protocol = smb2
        hosts allow = 192.168.86.0/24 127.0.0.1
        hosts deny = 0.0.0.0/0
        # guest account = nobody
        # map to guest = bad user
      '';
      shares = {
        clips = {
          path = "/home/samba/clips";
          comment = "The movie clips.";
          browseable = "yes";
          "read only" = "no";
          # So that when username and password are not provided or even are
          # wrong, the user can still connect. This is not desirable but since
          # we have hosts allow/deny, not a big problem.
          "guest ok" = "yes";
          "guest only" = "no";
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
