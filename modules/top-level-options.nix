{ config, lib, pkgs, ... } :

let cfg = config.bds;

in {
  options.bds = with lib; {
    machineType = mkOption {
      type = types.enum [ "laptop" "desktop" "server" ];
      default = "desktop";
      description = ''
        Specify the type of the machine.
        Based on the value, default settings can adjust automatically.
      '';
    };
  };

  config = {
    bds.desktop = {
      remote-desktop.enable = lib.mkDefault (builtins.getAttr cfg.machineType {
        desktop = true;
        server = true;
        laptop = false;
      });
      xserver.i3_show_battery = cfg.machineType == "laptop";
      xserver.useCapsAsCtrl = cfg.machineType == "laptop";
    };
  };
}
