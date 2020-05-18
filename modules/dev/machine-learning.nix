{ pkgs, lib, ... }:

let pythonForMachineLearning = pkgs.python3.withPackages (
      pythonPackages: with pythonPackages; [
        numpy
        pandas
        matplotlib

        # - Frameworks
        lightgbm
        pytorchWithCuda

        # - Tools
        jupyterlab
        plotly
        dash
      ]);

in {
  config = {
    environment.systemPackages = [ pythonForMachineLearning ];
  };
}
