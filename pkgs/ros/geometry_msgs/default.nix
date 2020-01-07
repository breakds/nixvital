{ stdenv, buildRosPackage, fetchFromGitHub,
 message_runtime, std_msgs, message_generation }:

let pname = "geometry_msgs";
    version = "1.12.7";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ message_runtime std_msgs message_generation ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "common_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0na2wvwd85h5zlwm32fjka1q03sqqrl39dmgcbj71z7p1hyzgijw";
  };

  meta = {
    description = "geometry_msgs";
    homepage = http://wiki.ros.org/geometry_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
