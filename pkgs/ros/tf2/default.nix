{ stdenv, buildRosPackage, fetchFromGitHub,
  tf2_msgs, rostime, geometry_msgs, console_bridge, boost162 }:

let pname = "tf2";
    version = "0.5.20";
    subversion = "0";
    rosdistro = "kinetic";

    bufferCorePatch = ./buffer_core.cpp.patch;

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ tf2_msgs rostime geometry_msgs console_bridge boost162 ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "geometry2-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1gjhhr77l0cms1qlz9valyf1znwhixygyxxydi3sr21l9hccgjjk";
  };

  patchPhase = ''
    patch ./src/buffer_core.cpp ${bufferCorePatch}
  '';

  meta = {
    description = "tf2";
    homepage = http://wiki.ros.org/tf2;
    license = stdenv.lib.licenses.bsd3;
  };
}
