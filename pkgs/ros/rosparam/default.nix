{ stdenv, buildRosPackage, fetchFromGitHub,
  rosPythonPackages,
  rosgraph
}:

let pname = "rosparam";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [
    rosgraph
    rosPythonPackages.pyyaml
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "14lg2nf4k4ypp0i9fzdxzjnjvshfc5malv83hfbzrjh60phgbd94";
  };

  meta = {
    description = "rosparam";
    homepage = http://wiki.ros.org/rosparam;
    license = stdenv.lib.licenses.bsd3;
  };
}
