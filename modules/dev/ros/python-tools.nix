# Prepare a python tools environment to build ROS.

{ lib, pkgs, stdenv, ... } :

with pkgs; with python2Packages;
  let catkin-pkg = callPackage ./catkin-pkg.nix {};
      rospkg = callPackage ./rospkg.nix {
        catkin-pkg = catkin-pkg;
      };
      rosdistro = callPackage ./rosdistro.nix {
        catkin-pkg = catkin-pkg;
        rospkg = rospkg;
      };
      rosinstall-generator = callPackage ./rosinstall-generator.nix {
        rosdistro = rosdistro;
      };
      vcstools = callPackage ./vcstools.nix {};
      wstool = callPackage ./wstool.nix {
        vcstools = vcstools;
      };
      rosinstall = callPackage ./rosinstall.nix {
        vcstools = vcstools;
        catkin-pkg = catkin-pkg;
        wstool = wstool;
        rosdistro = rosdistro;
      };
      ros-python-packages = python-packages: with python-packages; [
        catkin-pkg
        rospkg
        rosinstall-generator
        wstool
        rosinstall
      ];
  in python2.withPackages ros-python-packages
