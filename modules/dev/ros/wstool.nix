# TODO(breakds): Running unit tests.

{ lib, buildPythonPackage, fetchPypi, pytest,
  vcstools, ... }:

buildPythonPackage rec {
  pname = "wstool";
  version = "0.1.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c79b4f110ef17004c24972d742d2c5f606b0f6b424295e7ed029a48e857de237";
  };

  propagatedBuildInputs = [ vcstools ];

  checkInputs = [ pytest ];
  
  meta = {
    homepage = "http://wiki.ros.org/wstool";
    description = "Command-line tools for maintaining a workspace of projects from multiple version-control systems.";
    license = lib.licenses.bsd3;
  };
}
