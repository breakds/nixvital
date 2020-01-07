{ stdenv, buildRosPackage, fetchFromGitHub,
 roscpp_traits, rostime, cpp_common, roscpp_serialization }:

let pname = "roscpp_core";
    version = "0.6.11";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ roscpp_traits rostime cpp_common roscpp_serialization ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "roscpp_core-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0pl2jx3vbwmwjgnhg8g8nc3xvg8mzsmb3ccad5rwlxrf34726w3b";
  };

  meta = {
    description = "roscpp_core";
    homepage = http://wiki.ros.org/roscpp_core;
    license = stdenv.lib.licenses.bsd3;
  };
}
