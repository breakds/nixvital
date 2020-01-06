{ stdenv, buildRosPackage, fetchFromGitHub,
  genmsg}:

let pname = "gencpp";
    version = "0.6.0";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ genmsg ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "${pname}-release";
    rev = "release/${rosdistro}/${pname}/${version}-0";
    sha256 = "1wjizls8h2qjjq8aliwqvxd86p2jzll4cq66grzf8j7aj3dxvyl2";
  };

  meta = {
    description = "C++ ROS message and service generators";
    homepage = http://wiki.ros.org/gencpp;
    license = stdenv.lib.licenses.bsd3;
  };
}
