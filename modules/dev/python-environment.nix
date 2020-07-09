{ config, pkgs, lib, ... }:

let cfg = config.vital.dev.python;

    batteryOptions = {
      options = {
        machineLearning = lib.mkEnableOption ''
          Include the machine learning libraries, e.g. pytorch and lightbm.
        '';
        # FIXME: Currently jupyterhub does not yet work with jupyter
        # lab. Will make this working later.
        jupyterhub = lib.mkEnableOption ''
          Include jupyterhub.
        '';
      };
    };

in {
  options.vital.dev.python = {
    batteries = lib.mkOption {
      description = "Turn on batteries, which represents groups of python packages.";
      type = lib.types.submodule batteryOptions;
    };
  };
  
  config = let pythonWithBatteries = pkgs.callPackage ../../pkgs/dev/python-with-batteries.nix {
    enableMachineLearning = cfg.batteries.machineLearning;
    enableJupyterhub = cfg.batteries.jupyterhub;
  }; in {
    environment.systemPackages = with pkgs; [
      pythonWithBatteries 
    ] ++ (lib.optionals cfg.batteries.machineLearning [ opencv4 ]);
  };
}
