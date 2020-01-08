{ stdenv, buildRosPackage, fetchFromGitHub,
 roslaunch, python-rospkg, rosnode, rosgraph, rosservice, rostest, rosbuild, roslib, python-paramiko }:

let pname = "roswtf";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ roslaunch python-rospkg rosnode rosgraph rosservice rostest rosbuild roslib python-paramiko ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0yvrscsb4v4xmdlh5yydmdxqi8f51080pcgks7rz0k5g1yy1kh1q";
  };

  meta = {
    description = "roswtf";
    homepage = http://wiki.ros.org/roswtf;
    license = stdenv.lib.licenses.bsd3;
  };
}
