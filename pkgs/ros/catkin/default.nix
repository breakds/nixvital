{ stdenv, fetchFromGitHub,
  catkin-pkg, rospkg, empy, cmake, python2 }:

let pname = "catkin";
    version = "0.7.20";
    subversion = "1";
    rosdistro = "kinetic";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "${pname}-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "15yq3q9y3yf126qli6w7q0lywaj9gjrckqckfx8fak9j4g5hp3ac";
  };

  cmakeFlags = "-DCATKIN_ENABLE_TESTING=OFF -DSETUPTOOLS_DEB_LAYOUT=OFF";
  
  propagatedBuildInputs = [
    catkin-pkg rospkg empy cmake
  ];

  patchPhase = ''
    sed -i 's/PYTHON_EXECUTABLE/SHELL/' ./cmake/catkin_package_xml.cmake
    sed -i 's|#!/usr/bin/env bash|#!${stdenv.shell}|' ./cmake/templates/setup.bash.in
    sed -i 's|#!/usr/bin/env sh|#!${stdenv.shell}|' ./cmake/templates/setup.sh.in
    sed -i 's|#!/usr/bin/env python|#!${python2.interpreter}|' ./cmake/parse_package_xml.py
  '';

  meta = {
    description = "A CMake-based build system that is used to build all packages in ROS.";
    homepage = http://wiki.ros.org/catkin;
    license = stdenv.lib.licenses.bsd3;
  };
}
