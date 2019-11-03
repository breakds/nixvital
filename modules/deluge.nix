{ config, lib, pkgs, ... }:

let
  cfg = config.bds.bittorrent;
in {
  options.bds.bittorrent = {
    enable = lib.mkEnableOption "Deluge BitTorrent client";
  };

  config = lib.mkIf cfg.enable {
    services.deluge = {
      enable = true;

      declarative = true;
      openFirewall = true;
      user = "breakds";
      group = "breakds";
      authFile = "/home/breakds/.config/deluge/auth";
      
      config = {
        download_location = "/home/breakds/.deluge_stuff";
        daemon_port = 10733;
        listen_ports = [ 10781 10789 ];
        max_upload_speed = "1024";
      };

      web = {
        enable = true;
        port = 10780;
        openFirewall = true;
      };
    };
  };
}
