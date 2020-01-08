{ stdenv, buildRosPackage, fetchFromGitHub,
 geometry_msgs, message_runtime, rosbag_migration_rule, message_generation, std_msgs }:

let pname = "trajectory_msgs";
    version = "1.12.7";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ geometry_msgs message_runtime rosbag_migration_rule message_generation std_msgs ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "common_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1z41ywhia4l6ysd9zc4kxcillyk45r1bpl6hyfbb59pih1mkqi2y";
  };

  meta = {
    description = "trajectory_msgs";
    homepage = http://wiki.ros.org/trajectory_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
