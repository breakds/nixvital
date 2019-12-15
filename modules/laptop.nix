{ config, lib, pkgs, ... } :

{
  services.logind = {
    extraConfig = "HandleLidSwitch=ignore";
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };
}
