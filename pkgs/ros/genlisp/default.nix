{ stdenv, buildRosPackage, fetchFromGitHub,
  genmsg }:

let pname = "genlisp";
    version = "0.4.16";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ genmsg ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "genlisp-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0qndyl118h7y6amsydfaippb5lk1s2lbk38f4b88012522bgf1mf";
  };

  meta = {
    description = "genlisp";
    homepage = http://wiki.ros.org/genlisp;
    license = stdenv.lib.licenses.bsd3;
  };
}
