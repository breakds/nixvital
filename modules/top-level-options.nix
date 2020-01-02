{ config, lib, pkgs, ... } :

let cfg = config.vital;

in {
  options.vital = with lib; {
    machineType = mkOption {
      type = types.enum [ "laptop" "desktop" "server" ];
      default = "desktop";
      description = ''
        Specify the type of the machine.
        Based on the value, default settings can adjust automatically.
      '';
    };

    machineTags = mkOption {
      type = types.listOf (types.enum [ "weride" ]);
      default = [];
      description = ''
        The set of tags for the machine. 
        Specific packages and configs may be set based on this.
      '';
    };
  };

  config = {
    vital.desktop = {
      remote-desktop.enable = lib.mkDefault (builtins.getAttr cfg.machineType {
        desktop = true;
        server = true;
        laptop = false;
      });
      xserver.i3_show_battery = cfg.machineType == "laptop";
      xserver.useCapsAsCtrl = lib.mkDefault (cfg.machineType == "laptop");
    };
  };
}
