{ stdenv, buildRosPackage, fetchFromGitHub,
 graphviz, geometry_msgs, rostime, message_filters, roscpp, message_generation, tf2_ros, message_runtime, sensor_msgs, std_msgs, rosconsole, roswtf, angles }:

let pname = "tf";
    version = "1.11.9";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ graphviz geometry_msgs rostime message_filters roscpp message_generation tf2_ros message_runtime sensor_msgs std_msgs rosconsole roswtf angles ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "geometry-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0fc9jh9f2z00p4hqf13l0qsnq5a5pvby29liss9h03cx6kmyb22b";
  };

  meta = {
    description = "tf";
    homepage = http://wiki.ros.org/tf;
    license = stdenv.lib.licenses.bsd3;
  };
}
