{ stdenv, buildRosPackage, fetchFromGitHub,
  genmsg, python2Packages}:

let pname = "genpy";
    version = "0.6.7";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ genmsg python2Packages.pyyaml ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "${pname}-release";
    rev = "release/${rosdistro}/${pname}/${version}-0";
    sha256 = "1mvyiwn98n07nfsd2igx8g7laink4c7g5f7g1ljqqpsighrxn5jd";
  };

  meta = {
    description = "Python ROS message and service generators.";
    homepage = http://wiki.ros.org/genpy;
    license = stdenv.lib.licenses.bsd3;
  };
}
