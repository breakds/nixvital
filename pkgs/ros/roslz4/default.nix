{ stdenv, buildRosPackage, fetchFromGitHub,
 lz4 }:

let pname = "roslz4";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ lz4 ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0xs9px4rp2056cjqzwaizy280p808hv7fdkc9ya4b0cs9i082fyy";
  };

  meta = {
    description = "roslz4";
    homepage = http://wiki.ros.org/roslz4;
    license = stdenv.lib.licenses.bsd3;
  };
}
