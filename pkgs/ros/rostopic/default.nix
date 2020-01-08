{ stdenv, buildRosPackage, fetchFromGitHub,
 genpy, rosbag, rospy, rostest }:

let pname = "rostopic";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ genpy rosbag rospy rostest ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0zf06v7ffk7nrz84hgggf313da56byykk6xih25q93k9wvjlvrdz";
  };

  meta = {
    description = "rostopic";
    homepage = http://wiki.ros.org/rostopic;
    license = stdenv.lib.licenses.bsd3;
  };
}
