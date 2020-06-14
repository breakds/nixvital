{ config, pkgs, lib, ... }:

let cfg = config.vital.dev.python;

    batteryOptions = {
      options = {
        machineLearning = lib.mkEnableOption ''
          Include the machine learning libraries, e.g. pytorch and lightbm.
        '';
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
  
  config = {
    environment.systemPackages = [
      (let pythonWithBatteries = pkgs.python3.withPackages (
             pythonPackages: with pythonPackages;
               let the-torchvision = torchvision.override {
                     pytorch = pytorchWithCuda;
                   };
               in [ numpy pandas matplotlib jupyterlab jupyterlab plotly dash tqdm ]
                  ++ (lib.optionals cfg.batteries.machineLearning [ lightgbm pytorchWithCuda the-torchvision ])
                  ++ (lib.optionals cfg.batteries.jupyterhub [ jupyterhub ])
           );
       in pythonWithBatteries)
    ];
  };
}
