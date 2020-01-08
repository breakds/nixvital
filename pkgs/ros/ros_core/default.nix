{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "ros_core";
    version = "1.3.2";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "metapackages-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1bi9jqvby4inphd2x2hzdnwc0zfvhmav701cpai7ljlz43ivhwam";
  };

  meta = {
    description = "ros_core";
    homepage = http://wiki.ros.org/ros_core;
    license = stdenv.lib.licenses.bsd3;
  };
}
