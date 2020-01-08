{ stdenv, buildRosPackage, fetchFromGitHub,
 rospy, actionlib_msgs, tf2_py, message_filters, std_msgs, tf2_msgs, rosgraph, tf2, actionlib, geometry_msgs, roscpp, xmlrpcpp }:

let pname = "tf2_ros";
    version = "0.5.20";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ rospy actionlib_msgs tf2_py message_filters std_msgs tf2_msgs rosgraph tf2 actionlib geometry_msgs roscpp xmlrpcpp ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "geometry2-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0z328zc2dw3j6kimivvnb3y2jv4nnnc0dp0mvby35zrgknyc1n89";
  };

  meta = {
    description = "tf2_ros";
    homepage = http://wiki.ros.org/tf2_ros;
    license = stdenv.lib.licenses.bsd3;
  };
}
