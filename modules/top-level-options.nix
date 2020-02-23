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
    };

    # Handle lids for laptops.
    services.logind = lib.mkIf (cfg.machineType == "laptop") {
      # The following settings configures the following behavior for laptops
      # When the lid close event is detected,
      #   1. If the external power is on, do nothing
      #   2. If the laptop is docked (external dock or monitor or hub), do nothing
      #   3. Otherwise, it should go to suspend and then hibernate. However this action
      #      will be held off for 20 seconds to wait for the users to dock or plug
      #      external power.
      lidSwitch = "suspend-then-hibernate";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
      extraConfig = ''
        HoldoffTimeoutSec=20
      '';
    };
  };
}
