{ stdenv, buildRosPackage, fetchFromGitHub,
 boost162, rostime, roslz4, bzip2, cpp_common, roscpp_serialization, roscpp_traits }:

let pname = "rosbag_storage";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ boost162 rostime roslz4 bzip2 cpp_common roscpp_serialization roscpp_traits ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1q79a97s5l7xasx1p96sr47qh2praidl497slgjq6mgln9alpr1c";
  };

  meta = {
    description = "rosbag_storage";
    homepage = http://wiki.ros.org/rosbag_storage;
    license = stdenv.lib.licenses.bsd3;
  };
}
