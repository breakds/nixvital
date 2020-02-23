{ config, lib, pkgs, ... }:

let cfg = config.vital;

in {
  config = lib.mkIf (cfg.mainUser == "breakds") {
    vital.desktop = {
      xserver.useCapsAsCtrl = lib.mkDefault (cfg.machineType == "laptop");
    };
    environment.systemPackages = with pkgs; [
      breakds-texlive
    ];
  };
}
