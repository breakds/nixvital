{ stdenv, buildRosPackage, fetchFromGitHub,
  roscpp
  ,tf
  ,interactive_markers
  ,visualization_msgs
}:

let pname = "interactive_marker_tutorials";
    version = "0.10.3";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [
    roscpp
    tf
    interactive_markers
    visualization_msgs
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "visualization_tutorials-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "03s7bracg5ihnidi78df7vhfqlwmg6ph8mqkk6bxg40s2i28n4y2";
  };

  meta = {
    description = "interactive_marker_tutorials";
    homepage = http://wiki.ros.org/interactive_marker_tutorials;
    license = stdenv.lib.licenses.bsd3;
  };
}
