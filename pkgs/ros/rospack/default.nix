{ stdenv, buildRosPackage, fetchFromGitHub,
  rosPythonPackages,
  tinyxml
  ,pkg-config
  ,gtest
  ,ros_environment
  ,cmake_modules
  ,python
  ,boost162
}:

let pname = "rospack";
    version = "2.4.5";
    subversion = "1";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [
    tinyxml
    pkg-config
    gtest
    ros_environment
    cmake_modules
    python
    rosPythonPackages.catkin-pkg
    rosPythonPackages.rosdep
    boost162
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "rospack-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0hprzmcgsf8gba7dkjwq230g7rw9xs3bvc5njnw3j3caf5bc0rfh";
  };

  meta = {
    description = "rospack";
    homepage = http://wiki.ros.org/rospack;
    license = stdenv.lib.licenses.bsd3;
  };
}
