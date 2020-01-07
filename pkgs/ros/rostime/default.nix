{ stdenv, buildRosPackage, fetchFromGitHub,
  cpp_common }:

let pname = "rostime";
    version = "0.6.11";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ cpp_common ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "roscpp_core-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0500gr9y1vrwbhx2ihnyaprys7svpg2hxkk191y3x5b969lc8ibm";
  };

  meta = {
    description = "rostime";
    homepage = http://wiki.ros.org/rostime;
    license = stdenv.lib.licenses.bsd3;
  };
}
