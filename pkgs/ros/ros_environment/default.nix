{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "ros_environment";
    version = "1.0.1";
    subversion = "1";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_environment-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "06p237c68kgp1kw4iiydzqfkrjjgbcsvm4g8jyik69zrgakiif0v";
  };

  meta = {
    description = "ros_environment";
    homepage = http://wiki.ros.org/ros_environment;
    license = stdenv.lib.licenses.bsd3;
  };
}
