{ config, lib, pkgs, ... }:

{
  services.xserver.wacom.enable = true;
  
  environment.systemPackages = with pkgs; [
    libwacom  # provides configuration tools "xsetwacom"
  ];
}
