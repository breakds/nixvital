{ stdenv, buildRosPackage, fetchFromGitHub,
  rospack }:

let pname = "rosbash";
    version = "1.14.6";
    subversion = "1";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ rospack ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1dbbvhdaq6ab7qmalambdvscl11sbn9n127imcn31iilc0n0w9zx";
  };

  meta = {
    description = "rosbash";
    homepage = http://wiki.ros.org/rosbash;
    license = stdenv.lib.licenses.bsd3;
  };
}
