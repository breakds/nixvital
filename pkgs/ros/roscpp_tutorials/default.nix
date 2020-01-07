{ stdenv, buildRosPackage, fetchFromGitHub,
 roscpp, message_generation, std_msgs, rostime, message_runtime, roscpp_serialization, rosconsole }:

let pname = "roscpp_tutorials";
    version = "0.7.1";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ roscpp message_generation std_msgs rostime message_runtime roscpp_serialization rosconsole ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_tutorials-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1nylzays56dyyykah95lmsv7y8w309yjmg7dsj5m08hrnah26ji0";
  };

  meta = {
    description = "roscpp_tutorials";
    homepage = http://wiki.ros.org/roscpp_tutorials;
    license = stdenv.lib.licenses.bsd3;
  };
}
