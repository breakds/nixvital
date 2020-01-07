{ stdenv, buildRosPackage, fetchFromGitHub,
 rosconsole, pkg-config, roscpp_traits, roslang, message_generation, rostime, roscpp_serialization, message_runtime, rosgraph_msgs, std_msgs, cpp_common, xmlrpcpp }:

let pname = "roscpp";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ rosconsole pkg-config roscpp_traits roslang message_generation rostime roscpp_serialization message_runtime rosgraph_msgs std_msgs cpp_common xmlrpcpp ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0n82622sq2azn1hky3c7laxwdgfdrcbahbv5gabw4pm18x9razcr";
  };

  meta = {
    description = "roscpp";
    homepage = http://wiki.ros.org/roscpp;
    license = stdenv.lib.licenses.bsd3;
  };
}
