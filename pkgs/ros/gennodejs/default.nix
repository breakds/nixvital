{ stdenv, buildRosPackage, fetchFromGitHub,
  genmsg }:

let pname = "gennodejs";
    version = "2.0.1";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ genmsg ];

  src = fetchFromGitHub {
    owner = "RethinkRobotics-release";
    repo = "gennodejs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "077l2crbfq12dan5zg4hxi7x85m0nangmlxckh7a7ifggavzm7jh";
  };

  meta = {
    description = "gennodejs";
    homepage = http://wiki.ros.org/gennodejs;
    license = stdenv.lib.licenses.bsd3;
  };
}
