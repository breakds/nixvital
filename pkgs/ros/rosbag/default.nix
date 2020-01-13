{ stdenv, buildRosPackage, fetchFromGitHub,
  rosPythonPackages,
  cpp_common
  ,boost162
  ,genpy
  ,topic_tools
  ,xmlrpcpp
  ,rospy
  ,rosbag_storage
  ,genmsg
  ,std_srvs
  ,rosconsole
  ,roscpp_serialization
  ,roslib
  ,roscpp
}:

let pname = "rosbag";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [
    cpp_common
    rosPythonPackages.pillow
    boost162
    genpy
    topic_tools
    rosPythonPackages.rospkg
    xmlrpcpp
    rospy
    rosbag_storage
    genmsg
    std_srvs
    rosconsole
    roscpp_serialization
    roslib
    roscpp
  ];

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
