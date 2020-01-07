{ stdenv, buildRosPackage, fetchFromGitHub,
 std_msgs, nav_msgs, message_generation, message_runtime, sensor_msgs }:

let pname = "map_msgs";
    version = "1.13.0";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ std_msgs nav_msgs message_generation message_runtime sensor_msgs ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "navigation_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "115vffj9shhidpzjwww9yml7n6jmjw07b6243qr01mkfnfba9k6c";
  };

  meta = {
    description = "map_msgs";
    homepage = http://wiki.ros.org/map_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
