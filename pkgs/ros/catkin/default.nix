{ stdenv, fetchFromGitHub,
  catkin-pkg, rospkg, empy, cmake }:

let pname = "catkin";
    version = "0.7.20";
    subversion = "1";
    rosdistro = "kinetic";

    catkinPythonSetupPatch = ./catkin_python_setup.patch;
    pythonDistutilsInstallPatch = ./python_distutils_install.sh.in.patch;

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
    sed -i "s/check_output(\[/check_output(\['sh', /" ./python/catkin/environment_cache.py
    sed -i 's/COMMAND/COMMAND sh/' ./cmake/em_expand.cmake
    patch ./cmake/catkin_python_setup.cmake ${catkinPythonSetupPatch}
    patch ./cmake/templates/python_distutils_install.sh.in ${pythonDistutilsInstallPatch}
  '';

  meta = {
    description = "A CMake-based build system that is used to build all packages in ROS.";
    homepage = http://wiki.ros.org/catkin;
    license = stdenv.lib.licenses.bsd3;
  };
}
