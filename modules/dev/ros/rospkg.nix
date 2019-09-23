{ lib, buildPythonPackage, fetchPypi, pytest,
  pyyaml, catkin-pkg, ... }:

buildPythonPackage rec {
  pname = "rospkg";
  version = "1.1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f39f8b553a8524b1bf796a66c14b0466d2e7ac3ab8e933c1b3493e0bb8ca2cde";
  };

  propagatedBuildInputs = [ pyyaml catkin-pkg ];

  checkInputs = [ pytest ];

  meta = {
    homepage = "http://wiki.ros.org/rospkg";
    description = "Library for retrieving information about ROS packages and stacks.";
    license = lib.licenses.bsd3;
  };
}
