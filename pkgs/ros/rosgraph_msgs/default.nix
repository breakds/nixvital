{ stdenv, buildRosPackage, fetchFromGitHub,
 message_runtime, message_generation, std_msgs }:

let pname = "rosgraph_msgs";
    version = "1.11.2";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ message_runtime message_generation std_msgs ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1acyvalskr9hk23g2rsavpanjvnhq1cz467lnymyh4xd5g7xkrza";
  };

  meta = {
    description = "rosgraph_msgs";
    homepage = http://wiki.ros.org/rosgraph_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
