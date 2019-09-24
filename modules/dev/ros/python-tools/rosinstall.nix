# TODO(breakds): Running unit tests.

{ lib, buildPythonPackage, fetchPypi, pytest,
  vcstools, catkin-pkg, wstool, rosdistro, ... }:

buildPythonPackage rec {
  pname = "rosinstall";
  version = "0.7.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ba808bf8bac2cc3f13af9745184b9714c1426e11d09eb96468611b2ad47ed40";
  };

  propagatedBuildInputs = [ vcstools catkin-pkg wstool rosdistro ];

  checkInputs = [ pytest ];
  
  meta = {
    homepage = "http://wiki.ros.org/rosinstall";
    description = "The installer for ROS.";
    license = lib.licenses.bsd3;
  };
}
