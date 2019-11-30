{ config, lib, pkgs, ... } :

{
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
}
