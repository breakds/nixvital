{ pkgs, lib, ... }:

let pythonForMachineLearning = pkgs.python3.withPackages (
      pythonPackages: with pythonPackages;
        let the-torchvision = torchvision.override {
              pytorch = pytorchWithCuda;
            }; in [
              numpy
              pandas
              matplotlib

              # - Frameworks
              lightgbm
              pytorchWithCuda
              the-torchvision

              # - Tools
              jupyterlab
              plotly
              dash
              tqdm
            ]);

in {
  config = {
    environment.systemPackages = [ pythonForMachineLearning ];
  };
}
