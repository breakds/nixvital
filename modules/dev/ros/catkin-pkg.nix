# TODO(breakds): Running unit tests.

{ lib, buildPythonPackage, fetchPypi, pytest,
  docutils, pyparsing, python-dateutil, ... }:

buildPythonPackage rec {
  pname = "catkin_pkg";
  version = "0.4.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3aff32871b38630b2dad1b06eb96cac6b6b3f29adfef44f714fbdd3f12dba290";
  };

  propagatedBuildInputs = [ docutils pyparsing python-dateutil ];

  checkInputs = [ pytest ];
  
  meta = {
    homepage = "http://wiki.ros.org/catkin-pkg";
    description = "Library for retrieving information about catkin packages.";
    license = lib.licenses.bsd3;
  };
}
