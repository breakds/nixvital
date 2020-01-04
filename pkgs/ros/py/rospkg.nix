{ lib, buildPythonApplication, fetchPypi,
  catkin-pkg, pyyaml } :

let pname = "rospkg";
    version = "1.1.10";
    sha256 = "f39f8b553a8524b1bf796a66c14b0466d2e7ac3ab8e933c1b3493e0bb8ca2cde";

    propagatedBuildInputs = [ catkin-pkg pyyaml ];

    homepage = "http://wiki.ros.org/rospkg";
    description = "Library for retrieving information about ROS packages and stacks.";
    license = lib.licenses.bsd3;

in buildPythonApplication rec {
  inherit pname version;
  src = fetchPypi { inherit pname version sha256; };
  inherit propagatedBuildInputs;
  meta = with lib; {
    inherit homepage description license;
  };
}
