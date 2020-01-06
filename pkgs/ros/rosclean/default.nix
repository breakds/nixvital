{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "rosclean";
    version = "1.14.6";
    subversion = "1";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1xpmca1a66dwznja4syc639akhmnnjj1g7hzmshqi61vw0yws9gw";
  };

  meta = {
    description = "rosclean";
    homepage = http://wiki.ros.org/rosclean;
    license = stdenv.lib.licenses.bsd3;
  };
}
