{ stdenv, buildRosPackage, fetchFromGitHub,
 geometry_msgs, message_generation, actionlib_msgs }:

let pname = "tf2_msgs";
    version = "0.5.20";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ geometry_msgs message_generation actionlib_msgs ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "geometry2-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "03nvg4m557q950v1hn6wbczhx1cdy2nv9l7xvp41n7cfg2a7ngvv";
  };

  meta = {
    description = "tf2_msgs";
    homepage = http://wiki.ros.org/tf2_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
