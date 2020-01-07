{ stdenv, buildRosPackage, fetchFromGitHub,
 message_generation }:

let pname = "std_msgs";
    version = "0.5.11";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ message_generation ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "std_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0wb2c2m0c7ysfwmyanrkx7n1iy0xr7fawjp2vf6xmk5469jz2l9b";
  };

  meta = {
    description = "std_msgs";
    homepage = http://wiki.ros.org/std_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
