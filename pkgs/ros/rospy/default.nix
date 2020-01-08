{ stdenv, buildRosPackage, fetchFromGitHub,
 python-yaml, roscpp, python-rospkg, genpy, rosgraph, rosgraph_msgs, python-numpy, std_msgs, roslib }:

let pname = "rospy";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ python-yaml roscpp python-rospkg genpy rosgraph rosgraph_msgs python-numpy std_msgs roslib ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "19pzq3cz3gsdnfdl4phwzr109w3lcikxn53yyj4n0dc38rsg823g";
  };

  meta = {
    description = "rospy";
    homepage = http://wiki.ros.org/rospy;
    license = stdenv.lib.licenses.bsd3;
  };
}
