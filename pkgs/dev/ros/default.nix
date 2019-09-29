{ lib, pkgs, stdenv, callPackage, ... }:

let python-tools = callPackage ./python-tools {};
in stdenv.mkDerivation {
  name = "ros-kinetic";
  version = "kinetic";
  nativeBuildInputs = [ python-tools ];
  builder = ./builder.sh;
}
