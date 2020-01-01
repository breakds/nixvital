{ lib, pkgs, buildPythonPackage, fetchPypi, pytest,
  requests, requests-mock, ... }:

buildPythonPackage rec {
  pname = "percy";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07821yabrqjyg0z45xlm4vz4hgm4gs7p7mqa3hi5ryh1qhnn2f32";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [];

  doCheck = false;

  meta = {
    homepage = "https://github.com/percy/python-percy-client";
    description = "Python client library for visual regression testing with Percy";
    license = lib.licenses.mit;
  };
}
