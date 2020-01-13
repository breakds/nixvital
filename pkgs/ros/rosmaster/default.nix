{ stdenv, buildRosPackage, fetchFromGitHub,
  rosPythonPackages,
  rosgraph
}:

let pname = "rosmaster";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [
    rosPythonPackages.defusedxml
    rosgraph
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "18gqx7r1531zvhybm5rha5jcl7jck16p2yrrgxih40w5byx8zwmn";
  };

  meta = {
    description = "rosmaster";
    homepage = http://wiki.ros.org/rosmaster;
    license = stdenv.lib.licenses.bsd3;
  };
}
