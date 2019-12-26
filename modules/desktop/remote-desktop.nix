{ config, pkgs, lib, ... } :

let cfg = config.vital.desktop.remote-desktop;

in {

  options.vital.desktop.remote-desktop = with lib; {
    enable = mkEnableOption "Whether to enable the XRDP server";
    port = mkOption {
      type = types.port;
      description = "Port for the XRDP server";
      default = 3389;
    };
  };


  config = lib.mkIf (config.vital.desktop.enable && cfg.enable) {
    # Use mate for the remote desktop.
    services.xserver.desktopManager.mate.enable = true;
    
    services.xrdp = {
      enable = true;
      defaultWindowManager = "${config.services.xserver.displayManager.session.script} mate+none";
      port = cfg.port;
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
