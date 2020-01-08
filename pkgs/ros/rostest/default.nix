{ stdenv, buildRosPackage, fetchFromGitHub,
 boost162, rospy, rosgraph, rosmaster, rosunit, roslaunch }:

let pname = "rostest";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ boost162 rospy rosgraph rosmaster rosunit roslaunch ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1bfhxf09pslq364nl4kd0g1mfa7hni0r8h6pkn2m6jh5vd89wz7c";
  };

  meta = {
    description = "rostest";
    homepage = http://wiki.ros.org/rostest;
    license = stdenv.lib.licenses.bsd3;
  };
}
