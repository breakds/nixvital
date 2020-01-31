{ config, lib, pkgs, ... }:

let
  cfg = config.vital.bittorrent;
  delugePorts = (import ../../data/resources.nix).ports.deluge;
    
in {
  options.vital.bittorrent = {
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
        daemon_port = delugePorts.daemon;
        listen_ports = delugePorts.listen;
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
