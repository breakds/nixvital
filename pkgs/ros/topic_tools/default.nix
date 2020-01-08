{ stdenv, buildRosPackage, fetchFromGitHub,
 roscpp, rosunit, rosconsole, cpp_common, std_msgs, message_generation, rostest, xmlrpcpp, rostime, message_runtime }:

let pname = "topic_tools";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ roscpp rosunit rosconsole cpp_common std_msgs message_generation rostest xmlrpcpp rostime message_runtime ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0xrdsvpcvjq2h6zqapdsf2p4wm5lqdri3yzgldppzynxsywmpzky";
  };

  meta = {
    description = "topic_tools";
    homepage = http://wiki.ros.org/topic_tools;
    license = stdenv.lib.licenses.bsd3;
  };
}
