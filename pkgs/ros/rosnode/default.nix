{ stdenv, buildRosPackage, fetchFromGitHub,
 rostopic, rosgraph, rostest }:

let pname = "rosnode";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ rostopic rosgraph rostest ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1pmqgzy0jj88nz6d7q2vpf0hk0pb2q179bgq8azch1ivm8bjm61k";
  };

  meta = {
    description = "rosnode";
    homepage = http://wiki.ros.org/rosnode;
    license = stdenv.lib.licenses.bsd3;
  };
}
