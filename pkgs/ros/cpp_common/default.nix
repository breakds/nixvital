{ stdenv, buildRosPackage, fetchFromGitHub,
  boost, console_bridge }:

let pname = "cpp_common";
    version = "0.6.11";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ boost console_bridge ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "roscpp_core-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1xr926154i7kspnj4sb32vxl4q4jm178ncazq0hhvviwwh46nxpy";
  };

  meta = {
    description = "cpp_common";
    homepage = http://wiki.ros.org/cpp_common;
    license = stdenv.lib.licenses.bsd3;
  };
}
