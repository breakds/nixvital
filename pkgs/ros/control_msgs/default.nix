{ stdenv, buildRosPackage, fetchFromGitHub,
 geometry_msgs, std_msgs, message_runtime, message_generation, trajectory_msgs, actionlib_msgs }:

let pname = "control_msgs";
    version = "1.5.1";
    subversion = "1";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ geometry_msgs std_msgs message_runtime message_generation trajectory_msgs actionlib_msgs ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "control_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0qh0p42gs9g6fh7n7riq9qjafbinr5gr0g8c8ydfxrk1xihi06x7";
  };

  meta = {
    description = "control_msgs";
    homepage = http://wiki.ros.org/control_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
