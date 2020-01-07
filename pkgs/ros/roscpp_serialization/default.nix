{ stdenv, buildRosPackage, fetchFromGitHub,
  cpp_common, roscpp_traits, rostime }:

let pname = "roscpp_serialization";
    version = "0.6.11";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ cpp_common roscpp_traits rostime ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "roscpp_core-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1rgw9xvnbc64gbxc7aw797hbq49v1ql783msyf2njda4fcmwzwpp";
  };

  meta = {
    description = "roscpp_serialization";
    homepage = http://wiki.ros.org/roscpp_serialization;
    license = stdenv.lib.licenses.bsd3;
  };
}
