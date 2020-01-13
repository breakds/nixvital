{ stdenv, buildRosPackage, fetchFromGitHub,
  rosPythonPackages,
  rosgraph_msgs
  ,rosparam
  ,rosclean
  ,rosmaster
  ,roslib
  ,rosunit
  ,rosout
}:

let pname = "roslaunch";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [
    rosPythonPackages.paramiko
    rosgraph_msgs
    rosparam
    rosclean
    rosPythonPackages.pyyaml
    rosmaster
    roslib
    rosunit
    rosout
    rosPythonPackages.rospkg
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1s161h1jdqk9gq8l9w7n9fn1mk44sbzf0r8diq0bymphp54myf78";
  };

  meta = {
    description = "roslaunch";
    homepage = http://wiki.ros.org/roslaunch;
    license = stdenv.lib.licenses.bsd3;
  };
}
