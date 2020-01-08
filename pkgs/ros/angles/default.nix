{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "angles";
    version = "1.9.11";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "geometry_angles_utils-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0dvv03ak9zpi9ng6a5xfxcxp8pm9k1xv6w7yd81ah5zhy2qknrm3";
  };

  meta = {
    description = "angles";
    homepage = http://wiki.ros.org/angles;
    license = stdenv.lib.licenses.bsd3;
  };
}
