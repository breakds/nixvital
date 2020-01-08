{ stdenv, buildRosPackage, fetchFromGitHub,
 std_msgs, message_runtime, message_generation }:

let pname = "diagnostic_msgs";
    version = "1.12.7";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ std_msgs message_runtime message_generation ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "common_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0z87q1mrfgzwdjv5j3l4m0900j6bjjlp9s1d9vvcbkv9khprhan7";
  };

  meta = {
    description = "diagnostic_msgs";
    homepage = http://wiki.ros.org/diagnostic_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
