{ stdenv, buildRosPackage, fetchFromGitHub,
  console_bridge, rosconsole }:

let pname = "rosconsole_bridge";
    version = "0.5.2";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ console_bridge rosconsole ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "rosconsole_bridge-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0y6j9w8p3gifq6jv5931d15gv3c12yfsaikncfrf628abp037sj8";
  };

  meta = {
    description = "rosconsole_bridge";
    homepage = http://wiki.ros.org/rosconsole_bridge;
    license = stdenv.lib.licenses.bsd3;
  };
}
