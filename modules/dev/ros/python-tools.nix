# Prepare a python tools environment to build ROS.

{ lib, pkgs, ... } :

with pkgs; with python2Packages;
  let catkin-pkg = callPackage ./catkin-pkg.nix {};
      rospkg = callPackage ./rospkg.nix {
        catkin-pkg = catkin-pkg;
      };
      ros-python-packages = python-packages: with python-packages; [
        catkin-pkg
        rospkg
      ];
  in python2.withPackages ros-python-packages
