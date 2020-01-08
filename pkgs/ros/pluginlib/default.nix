{ stdenv, buildRosPackage, fetchFromGitHub,
 cmake_modules, class_loader, rosconsole, roslib, tinyxml-2 }:

let pname = "pluginlib";
    version = "1.11.3";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ cmake_modules class_loader rosconsole roslib tinyxml-2 ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "pluginlib-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "02839189dai06kahccs1mrp38hmf5823irj7liknm67fgsn8zj33";
  };

  meta = {
    description = "pluginlib";
    homepage = http://wiki.ros.org/pluginlib;
    license = stdenv.lib.licenses.bsd3;
  };
}
