{ stdenv, buildRosPackage, fetchFromGitHub,
 genpy, rosmsg, rosgraph, roslib, rospy }:

let pname = "rosservice";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ genpy rosmsg rosgraph roslib rospy ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0n339cakpmdrjr4k2lhspxk9khy405pga800r6qzpzgl84i1g4g6";
  };

  meta = {
    description = "rosservice";
    homepage = http://wiki.ros.org/rosservice;
    license = stdenv.lib.licenses.bsd3;
  };
}
