{ stdenv, buildRosPackage, fetchFromGitHub,
 geometry_msgs, message_runtime, std_msgs, message_generation }:

let pname = "shape_msgs";
    version = "1.12.7";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ geometry_msgs message_runtime std_msgs message_generation ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "common_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "072wbwk1r7yz35ay669sh2lypys9wl1pr39dasx6b0a2hyvhx01v";
  };

  meta = {
    description = "shape_msgs";
    homepage = http://wiki.ros.org/shape_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
