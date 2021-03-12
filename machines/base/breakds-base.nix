{ config, lib, pkgs, ... }:

let cfg = config.vital;

    isWeride = lib.any (x: x == "weride") cfg.machineTags;

in {
  config = lib.mkIf (cfg.mainUser == "breakds") {
    vital.desktop = {
      xserver.useCapsAsCtrl = lib.mkDefault (cfg.machineType == "laptop");
    };
    
    users.extraUsers = {
      "breakds" = {
        shell = pkgs.zsh;
        useDefaultShell = false;
      };
    };
      
    environment.systemPackages = with pkgs; [
      breakds-texlive

      # For C++ Development
      include-what-you-use
      cgal
      emscripten

      # For Lisp Development
      lispPackages.quicklisp

      # For Nixpkgs Development
      nixpkgs-review

      # Other useful packages
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
      parted
      gparted
      steam-run-native
      discord
      python3Packages.gdown

      # Entertainment
      strawberry

      # Cloud
      awscli2
    ] ++ (if isWeride then [] else [ pkgs.bazel ]);


    # Enable nix flakes
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
  };
}
