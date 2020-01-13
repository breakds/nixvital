{ stdenv, buildRosPackage, fetchFromGitHub,
  qt5,
  rosPythonPackages,
  rosbuild,
  writeText
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
    rosPythonPackages.sip
    rosbuild
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "python_qt_binding-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1glg3c317lgbxkyira2g5ds974qrwv8gf5484rx2klh9z04hznah";
  };

  # Credit to lopsided98
  postPatch = ''
    sed -e "s#sipconfig\._pkg_config\['default_sip_dir'\]#'${rosPythonPackages.pyqt5}/share/sip'#" \
        -e "s#qtconfig\['QT_INSTALL_HEADERS'\]#'${qt5.qtbase.dev}/include'#g" \
        -i cmake/sip_configure.py
  '';

  setupHook = writeText "python-qt-binding-setup-hook" ''
    _pythonQtBindingPreFixupHook() {
      # Prevent /build RPATH references
      rm -rf devel/lib
    }
    preFixupHooks+=(_pythonQtBindingPreFixupHook)
  '';

  meta = {
    description = "python_qt_binding";
    homepage = http://wiki.ros.org/python_qt_binding;
    license = stdenv.lib.licenses.bsd3;
  };
}
