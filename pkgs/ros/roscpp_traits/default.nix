{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "roscpp_traits";
    version = "0.6.11";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "roscpp_core-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0pgwzd2yzsqfap80n6wcnj0jip1z3cghw49mihyf8w0q3lfz6yf6";
  };

  meta = {
    description = "roscpp_traits";
    homepage = http://wiki.ros.org/roscpp_traits;
    license = stdenv.lib.licenses.bsd3;
  };
}
