{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "rosunit";
    version = "1.14.6";
    subversion = "1";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1r8igvbmyhnwjflianshifcykgpvbcfcs4smg1qf78bb0grh6a7w";
  };

  meta = {
    description = "rosunit";
    homepage = http://wiki.ros.org/rosunit;
    license = stdenv.lib.licenses.bsd3;
  };
}
