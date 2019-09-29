{ lib, buildPythonPackage, fetchFromGitHub,
  catkin-pkg, ... }:

buildPythonPackage rec {
  pname = "catkin";
  version = "0.7.18";
  subversion =  "1";
  rosdistro = "kinetic";

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "${pname}-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1hqzc58piv241ik2az0wbx4adcflihprfzf0zhrdcm40yzh2md3x";
  };

  propagatedBuildInputs = [];
  
  doCheck = false;

  meta = {
    homepage = "http://wiki.ros.org/catkin";
    description = "A CMake-based build system that is used to build all packages in ROS";
    license = lib.licenses.bsd3;
  };
}
