{ stdenv, buildRosPackage, fetchFromGitHub,
  rosPythonPackages,
  sensor_msgs,
  qt5,
  map_msgs,
  eigen,
  message_filters,
  tinyxml,
  roscpp,
  tf,
  cmake_modules,
  rosbag,
  libGL,
  libGLU,
  assimp,
  rosconsole,
  resource_retriever,
  std_srvs,
  std_msgs,
  python_qt_binding,
  rospy,
  image_transport,
  geometry_msgs,
  libyamlcpp,
  pluginlib,
  nav_msgs,
  urdfdom_headers,
  media_export,
  roslib,
  urdf,
  interactive_markers,
  ogre1_9,
  laser_geometry,
  visualization_msgs,
}:

let pname = "rviz";
    version = "1.12.17";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  propagatedBuildInputs  = [
    sensor_msgs
    map_msgs
    eigen
    message_filters
    tinyxml
    roscpp
    tf
    qt5.qtbase
    rosPythonPackages.sip
    cmake_modules
    rosbag
    libGL
    libGLU
    assimp
    rosconsole
    resource_retriever
    std_srvs
    std_msgs
    python_qt_binding
    rospy
    image_transport
    geometry_msgs
    libyamlcpp
    pluginlib
    nav_msgs
    urdfdom_headers
    media_export
    roslib
    urdf
    interactive_markers
    ogre1_9
    laser_geometry
    visualization_msgs
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "rviz-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "03ykxqfh7p7vpgcivyx2s4z87mybpnqk4ni2rrn7irzw79hga9aj";
  };

  # FIXME: Still cannot run. Stuck at splash screen
  postFixup = ''
    wrapQtApp $out/bin/rviz
  '';

  meta = {
    description = "rviz";
    homepage = http://wiki.ros.org/rviz;
    license = stdenv.lib.licenses.bsd3;
  };
}
