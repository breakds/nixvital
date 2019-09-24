# TODO(breakds): Running unit tests.

{ lib, buildPythonPackage, fetchPypi, pytest,
  pyyaml, rosdistro, ... }:

buildPythonPackage rec {
  pname = "rosinstall_generator";
  version = "0.1.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e6a2c60e9262075dd584a592fcddf9f2c402db1a72676b0bd442da716c708c0";
  };

  propagatedBuildInputs = [ pyyaml rosdistro ];

  checkInputs = [ pytest ];
  
  meta = {
    homepage = "http://wiki.ros.org/rosinstall_generator";
    description = "A tool for generating rosinstall files";
    license = lib.licenses.bsd3;
  };
}
