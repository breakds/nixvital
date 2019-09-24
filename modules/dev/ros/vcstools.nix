# TODO(breakds): Running unit tests.

{ lib, buildPythonPackage, fetchPypi, pytest,
  pyyaml, dateutil, nose, ... }:

buildPythonPackage rec {
  pname = "vcstools";
  version = "0.1.42";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e48d8ed8b0fdda739af56e05bf10da1a509cb7d4950a19c73264c770802777a";
  };

  propagatedBuildInputs = [ pyyaml dateutil ];

  checkInputs = [ nose ];

  checkPhase = "nosetests vcstools";
  
  meta = {
    homepage = "https://github.com/vcstools/vcstools";
    description = "Python library for interacting with various VCS systems.";
    license = lib.licenses.bsd3;
  };
}
