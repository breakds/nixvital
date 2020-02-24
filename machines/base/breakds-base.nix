{ config, lib, pkgs, ... }:

let cfg = config.vital;

in {
  config = lib.mkIf (cfg.mainUser == "breakds") {
    vital.desktop = {
      xserver.useCapsAsCtrl = lib.mkDefault (cfg.machineType == "laptop");
    };
    environment.systemPackages = with pkgs; [
      breakds-texlive

      # For Lisp Development
      lispPackages.quicklisp

      # Other useful packages
      meld
      wesnoth
      httpie
      gnupg
      pass
      ledger
      graphviz
      feh
      graphicsmagick
      hugo
      quickserve      
    ];
  };
}
