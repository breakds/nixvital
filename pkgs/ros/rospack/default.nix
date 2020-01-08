{ stdenv, buildRosPackage, fetchFromGitHub,
 pkg-config, cmake_modules, python-rosdep, python, gtest, ros_environment, tinyxml, boost162, python-catkin-pkg }:

let pname = "rospack";
    version = "2.4.5";
    subversion = "1";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ pkg-config cmake_modules python-rosdep python gtest ros_environment tinyxml boost162 python-catkin-pkg ];

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
