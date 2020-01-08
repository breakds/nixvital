{ stdenv, buildRosPackage, fetchFromGitHub,
 geometry_msgs, actionlib_msgs, nav_msgs, sensor_msgs, visualization_msgs, shape_msgs, trajectory_msgs, stereo_msgs, diagnostic_msgs }:

let pname = "common_msgs";
    version = "1.12.7";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ geometry_msgs actionlib_msgs nav_msgs sensor_msgs visualization_msgs shape_msgs trajectory_msgs stereo_msgs diagnostic_msgs ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "common_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1nracy5nkxc9v16inh2k7n67mdzcc81yzlbkavsaby7nrja2cq1g";
  };

  meta = {
    description = "common_msgs";
    homepage = http://wiki.ros.org/common_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
