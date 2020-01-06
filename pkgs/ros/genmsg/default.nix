{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "genmsg";
    version = "0.5.11";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "${pname}-release";
    rev = "release/${rosdistro}/${pname}/${version}-0";
    sha256 = "04ya9x910yvbpk883y3cpw2kmbkg8l8hl808sh79cyk4ff6hd0wf";
  };

  meta = {
    description = "Standalone Python library for generating ROS message and service data structures for various languages.";
    homepage = http://wiki.ros.org/genmsg;
    license = stdenv.lib.licenses.bsd3;
  };
}
