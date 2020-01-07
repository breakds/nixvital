{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "cmake_modules";
    version = "0.4.2";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "cmake_modules-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "11kh2z059ffxgjzrzh9jgdln3fhydh799bc590kfgxcqjx0kqpli";
  };

  meta = {
    description = "cmake_modules";
    homepage = http://wiki.ros.org/cmake_modules;
    license = stdenv.lib.licenses.bsd3;
  };
}
