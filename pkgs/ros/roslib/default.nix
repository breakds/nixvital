{ stdenv, buildRosPackage, fetchFromGitHub,
  rosPythonPackages,
  ros_environment
  ,boost162
  ,rospack
}:

let pname = "roslib";
    version = "1.14.6";
    subversion = "1";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [
    ros_environment
    boost162
    rosPythonPackages.rospkg
    rospack
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1zsx3jp24aipvv97pb4527825xd70hh71q4k5lz3agsdypgnrmwr";
  };

  meta = {
    description = "roslib";
    homepage = http://wiki.ros.org/roslib;
    license = stdenv.lib.licenses.bsd3;
  };
}
