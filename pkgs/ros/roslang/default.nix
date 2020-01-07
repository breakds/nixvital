{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "roslang";
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
    sha256 = "1n6775x93p87hjzdlq43h2h9fk7blcabyqca4gwrag0yxcmf52cj";
  };

  meta = {
    description = "roslang";
    homepage = http://wiki.ros.org/roslang;
    license = stdenv.lib.licenses.bsd3;
  };
}
