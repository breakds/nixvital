{ stdenv, buildRosPackage, fetchFromGitHub,
 xmlrpcpp, roscpp_serialization, rosbag_storage, cpp_common, boost162, python-imaging, genmsg, roscpp, python-rospkg, std_srvs, rospy, roslib, topic_tools, rosconsole, genpy }:

let pname = "rosbag";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ xmlrpcpp roscpp_serialization rosbag_storage cpp_common boost162 python-imaging genmsg roscpp python-rospkg std_srvs rospy roslib topic_tools rosconsole genpy ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0sxd4d49nnyq4741wzq4d6qk7kwgkzwf6vbpykwaybmb5fysjk5y";
  };

  meta = {
    description = "rosbag";
    homepage = http://wiki.ros.org/rosbag;
    license = stdenv.lib.licenses.bsd3;
  };
}
