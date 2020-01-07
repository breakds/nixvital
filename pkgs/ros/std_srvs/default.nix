{ stdenv, buildRosPackage, fetchFromGitHub,
 message_generation, message_runtime }:

let pname = "std_srvs";
    version = "1.11.2";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ message_generation message_runtime ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1lrc01bxlh4arcjaxa1vlzvhvcp5xd4ia0g01pbblmmhvyfy06s7";
  };

  meta = {
    description = "std_srvs";
    homepage = http://wiki.ros.org/std_srvs;
    license = stdenv.lib.licenses.bsd3;
  };
}
