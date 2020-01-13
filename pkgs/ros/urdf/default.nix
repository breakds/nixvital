{ stdenv, buildRosPackage, fetchFromGitHub,
  urdf_parser_plugin,
  pluginlib,
  urdfdom_headers,
  urdfdom,
  rosconsole_bridge,
  tinyxml,
  roscpp,
  cmake_modules,
}:

let pname = "urdf";
    version = "1.12.12";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [
    urdf_parser_plugin
    pluginlib
    rosconsole_bridge
    tinyxml
    roscpp
    cmake_modules
    urdfdom_headers
    urdfdom
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "urdf-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1dsvad8hym385lrjilbdhawgaxwv5qgxibm4d6fpxbm6a2mpixs2";
  };

  meta = {
    description = "urdf";
    homepage = http://wiki.ros.org/urdf;
    license = stdenv.lib.licenses.bsd3;
  };
}
