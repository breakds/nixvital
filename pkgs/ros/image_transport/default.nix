{ stdenv, buildRosPackage, fetchFromGitHub,
 message_filters, roslib, rosconsole, roscpp, sensor_msgs, pluginlib }:

let pname = "image_transport";
    version = "1.11.13";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ message_filters roslib rosconsole roscpp sensor_msgs pluginlib ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "image_common-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "09f998cacs3z958kn1vna1ma0vqfl3wbyzygq8kqx61x1wz9mfhm";
  };

  meta = {
    description = "image_transport";
    homepage = http://wiki.ros.org/image_transport;
    license = stdenv.lib.licenses.bsd3;
  };
}
