# Modified from https://github.com/airalab/airapkgs

{ stdenv, cmake, pythonPackages, catkin }:

{ nativeBuildInputs ? [],
  doCheck ? true,
  ... }@attrs:

stdenv.mkDerivation(attrs // rec {
  # FIXME: In the future do not just use propagatedbuildinputs as the
  # target arch might be different.
  propagatedBuildInputs = [
    cmake catkin pythonPackages.wrapPython
  ] ++ (attrs.propagatedBuildInputs or []);

  doCheck = attrs.doCheck or false;

  cmakeFlags = "-DCATKIN_ENABLE_TESTING=${if doCheck then "ON" else "OFF"} -DSETUPTOOLS_DEB_LAYOUT=OFF -DCMAKE_BUILD_TYPE=Release";

  preConfigure = ''
    if [ ! -e CMakeLists.txt ]; then
      catkin_init_workspace
    fi
  '';
})
