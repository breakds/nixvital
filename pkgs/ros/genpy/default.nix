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
    sha256 = "1wjizls8h2qjjq8aliwqvxd86p2jzll4cq66grzf8j7aj3dxvyl2";
  };

  meta = {
    description = "Python ROS message and service generators.";
    homepage = http://wiki.ros.org/genpy;
    license = stdenv.lib.licenses.bsd3;
  };
}
