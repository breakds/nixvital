{ stdenv, buildRosPackage, fetchFromGitHub,
 cmake_modules, boost162, console_bridge, poco }:

let pname = "class_loader";
    version = "0.3.9";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ cmake_modules boost162 console_bridge poco ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "class_loader-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "13yfm2jhhksr27vzg62wyac6il20gjfb7dz2sxznl65pd2pjxi2q";
  };

  meta = {
    description = "class_loader";
    homepage = http://wiki.ros.org/class_loader;
    license = stdenv.lib.licenses.bsd3;
  };
}
