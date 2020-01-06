# Modified from https://github.com/airalab/airapkgs

{ stdenv, cmake, ros-python, catkin }:

attrs:

stdenv.mkDerivation(attrs // rec {
  propagatedBuildInputs = [
    cmake ros-python catkin] ++ (attrs.propagatedBuildInputs or []);

  doCheck = attrs.doCheck or false;

  ROS_LANG_DISABLE = "geneus:genlisp:gennodejs";

  cmakeFlags = "-DCATKIN_ENABLE_TESTING=${if doCheck then "ON" else "OFF"} -DSETUPTOOLS_DEB_LAYOUT=OFF";

  preConfigure = ''
    if [ ! -e CMakeLists.txt ]; then
      catkin_init_workspace
    fi
  '';
})
