# Check https://github.com/airalab/airapkgs/blob/nixos-unstable/pkgs/development/ros-modules/catkin/default.nix

{ lib, pkgs, stdenv, fetchFromGitHub, callPackage,
  python2Packages, ... }:

let
  pname = "catkin";
  version = "0.7.18";
  subversion =  "1";
  rosdistro = "kinetic";
  python-tools = callPackage ../python-tools {};
in stdenv.mkDerivation {
  name = "${pname}-${version}";

  NIX_DEBUG = 2;

  # src = fetchFromGitHub {
  #   owner = "ros-gbp";
  #   repo = "${pname}-release";
  #   rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
  #   sha256 = "1hqzc58piv241ik2az0wbx4adcflihprfzf0zhrdcm40yzh2md3x";    
  # };

  src = ./catkin;

  cmakeFlags = "-DCATKIN_ENABLE_TESTING=OFF -DSETUPTOOLS_DEB_LAYOUT=OFF";  

  propagatedBuildInputs = [ python-tools pkgs.cmake ];

  patchPhase = ''
    sed -i 's/PYTHON_EXECUTABLE/SHELL/' ./cmake/catkin_package_xml.cmake
    sed -i 's|#!/usr/bin/env bash|#!${stdenv.shell}|' ./cmake/templates/setup.bash.in
    sed -i 's|#!/usr/bin/env sh|#!${stdenv.shell}|' ./cmake/templates/setup.sh.in
    sed -i 's|#!/usr/bin/env sh|#!${stdenv.shell}|' ./cmake/templates/env.sh.in
    sed -i 's|#!/bin/sh|#!${stdenv.shell}|' ./cmake/templates/python_distutils_install.sh.in
    sed -i 's|#!/usr/bin/env|#!${stdenv.shell}|' ./cmake/templates/python_distutils_install.sh.in
    sed -i 's|#!/usr/bin/env python|#!${python-tools}/bin/python|' ./cmake/parse_package_xml.py
  '';

  meta = {
    homepage = "http://wiki.ros.org/catkin";
    description = "A CMake-based build system that is used to build all packages in ROS";
    license = lib.licenses.bsd3;
  };
}
