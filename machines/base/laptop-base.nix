{ config, lib, pkgs, ... }:

let cfg = config.vital;

in {
  config = lib.mkIf (cfg.machineType == "laptop") {
    # Handle lids for laptops.
    services.logind = {
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
        HoldoffTimeoutSec=60
      '';
    };
  };
}
