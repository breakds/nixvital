{ stdenv, buildRosPackage, fetchFromGitHub,
  qt5,
  rosPythonPackages,
  rosbuild
}:

let pname = "python_qt_binding";
    version = "0.3.4";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [
    qt5.qtbase
    rosPythonPackages.pyqt5
    rosbuild
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "python_qt_binding-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1glg3c317lgbxkyira2g5ds974qrwv8gf5484rx2klh9z04hznah";
  };

  meta = {
    description = "python_qt_binding";
    homepage = http://wiki.ros.org/python_qt_binding;
    license = stdenv.lib.licenses.bsd3;
  };
}
