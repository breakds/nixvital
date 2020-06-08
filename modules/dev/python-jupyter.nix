{ pkgs, lib, ... }:

let pythonJupyter = pkgs.python3.withPackages (
      pythonPackages: with pythonPackages; [
        numpy
        pandas
        matplotlib

        # - Frameworks
        lightgbm

        # - Tools
        jupyterlab
        plotly
        dash
        tqdm
      ]);

in {
  config = {
    environment.systemPackages = [ pythonJupyter ];
  };
}
