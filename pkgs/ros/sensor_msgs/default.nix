{ stdenv, buildRosPackage, fetchFromGitHub,
 message_generation, message_runtime, geometry_msgs, std_msgs }:

let pname = "sensor_msgs";
    version = "1.12.7";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ message_generation message_runtime geometry_msgs std_msgs ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "common_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1a92rg3b63w5fqdld8ixnj8gibwl33snqfx2s6386bjllwmc9w48";
  };

  meta = {
    description = "sensor_msgs";
    homepage = http://wiki.ros.org/sensor_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
