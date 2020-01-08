{ stdenv, buildRosPackage, fetchFromGitHub,
 rospy, tf2 }:

let pname = "tf2_py";
    version = "0.5.20";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ rospy tf2 ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "geometry2-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0pvfx2xb1mc4c6k1ph1pbasqllm4n1cz658f3i4zspm71s4v3cfx";
  };

  meta = {
    description = "tf2_py";
    homepage = http://wiki.ros.org/tf2_py;
    license = stdenv.lib.licenses.bsd3;
  };
}
