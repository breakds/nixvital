{ stdenv, buildRosPackage, fetchFromGitHub,
  roscpp
  ,tf
  ,rospy
  ,visualization_msgs
  ,rosconsole
  ,std_msgs
  ,rostest
}:

let pname = "interactive_markers";
    version = "1.11.4";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [
    roscpp
    tf
    rospy
    visualization_msgs
    rosconsole
    std_msgs
    rostest
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "interactive_markers-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "19l1vgzxzrizn6djabh2h6ix8ivrxzj93lsc5873yas9d8qngggs";
  };

  meta = {
    description = "interactive_markers";
    homepage = http://wiki.ros.org/interactive_markers;
    license = stdenv.lib.licenses.bsd3;
  };
}
