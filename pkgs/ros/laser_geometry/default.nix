{ stdenv, buildRosPackage, fetchFromGitHub,
  rosPythonPackages,
  cmake_modules
  ,boost162
  ,eigen
  ,tf
  ,angles
  ,roscpp
  ,sensor_msgs
}:

let pname = "laser_geometry";
    version = "1.6.4";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [
    cmake_modules
    boost162
    eigen
    rosPythonPackages.numpy
    tf
    angles
    roscpp
    sensor_msgs
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "laser_geometry-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1jcmp2f2dm7masl8m8lxy29lh7631zlrkl02iwwqlc1snkrgvh94";
  };

  meta = {
    description = "laser_geometry";
    homepage = http://wiki.ros.org/laser_geometry;
    license = stdenv.lib.licenses.bsd3;
  };
}
