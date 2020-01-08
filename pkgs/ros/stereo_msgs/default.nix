{ stdenv, buildRosPackage, fetchFromGitHub,
 sensor_msgs, message_generation, message_runtime, std_msgs }:

let pname = "stereo_msgs";
    version = "1.12.7";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ sensor_msgs message_generation message_runtime std_msgs ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "common_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0ln46hiimh364m4fhgr4h1bdk59i9734bqf5barfg8cws04pwjq6";
  };

  meta = {
    description = "stereo_msgs";
    homepage = http://wiki.ros.org/stereo_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
