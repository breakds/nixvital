{ stdenv, buildRosPackage, fetchFromGitHub,
 roscpp, rosgraph_msgs }:

let pname = "rosout";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ roscpp rosgraph_msgs ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "03cz52q9gwcvb245lbxz4z7h24cgl6g0a0c2kfw693cqr6dmgwhw";
  };

  meta = {
    description = "rosout";
    homepage = http://wiki.ros.org/rosout;
    license = stdenv.lib.licenses.bsd3;
  };
}
