# TODO(breakds): Running unit tests.

{ lib, buildPythonPackage, fetchPypi, pytest,
  pyyaml, catkin-pkg, rospkg, ... }:

buildPythonPackage rec {
  pname = "rosdistro";
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "266e1a27d939a6a3c1f3e4dc3043f4b8306601b5ca1cb96ef8e5904ac2d397ef";
  };

  propagatedBuildInputs = [ pyyaml catkin-pkg rospkg ];

  checkInputs = [ pytest ];
  
  meta = {
    homepage = "https://pypi.org/project/rosdistro/";
    description = "A tool to work with rosdistro files";
    license = lib.licenses.bsd3;
  };
}
