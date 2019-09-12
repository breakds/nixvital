{config, lib, pkgs, ...}:

let my-python-packages = python-packages: with python-packages; [
      setuptools
    ];
    python-with-my-packages = pkgs.python.withPackages my-python-packages;
in {
   environment.systemPackages = [
     python-with-my-packages
   ];
}
