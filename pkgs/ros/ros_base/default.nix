{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "ros_base";
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
    sha256 = "0ddcyv95vika0w9iqc10yk7dsz2l5xs0in3pj1n8wp1b9d88ahhp";
  };

  meta = {
    description = "ros_base";
    homepage = http://wiki.ros.org/ros_base;
    license = stdenv.lib.licenses.bsd3;
  };
}
