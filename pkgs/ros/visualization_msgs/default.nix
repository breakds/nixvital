{ stdenv, buildRosPackage, fetchFromGitHub,
 message_runtime, message_generation, std_msgs, geometry_msgs }:

let pname = "visualization_msgs";
    version = "1.12.7";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ message_runtime message_generation std_msgs geometry_msgs ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "common_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "13c8mmflnl6wgnpvvha6qb5x07v542imyg6cal4g3s29c95rjilq";
  };

  meta = {
    description = "visualization_msgs";
    homepage = http://wiki.ros.org/visualization_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
