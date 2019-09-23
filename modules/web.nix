{ config, lib, pkgs, ... }:

{

  # Nginx
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
  };
  
  services.nextcloud = {
    enable = true;
    hostName = "nas.breakds.org";
    home = "/home/breakds/nas";
    
    config = {
      adminpass = "asdf";
    };
  };
}
