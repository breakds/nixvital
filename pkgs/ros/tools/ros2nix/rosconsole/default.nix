{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "rosconsole";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1qyv4gncm30yakj2mybw99n9c4gn786w139d6bpsl4jscpk79mvm";
  };

  meta = {
    description = "rosconsole";
    homepage = http://wiki.ros.org/rosconsole;
    license = stdenv.lib.licenses.bsd3;
  };
}
