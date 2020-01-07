{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "rosmsg";
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
    sha256 = "1bjg96zzssrxplw2l5h49rb37h339alwfhr8mfzxh99hpcpwfygr";
  };

  meta = {
    description = "rosmsg";
    homepage = http://wiki.ros.org/rosmsg;
    license = stdenv.lib.licenses.bsd3;
  };
}
