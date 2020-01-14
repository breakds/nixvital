let pkgs = import <nixpkgs> {
      config.allowUnfree = true;
      overlays = [ (import ./default.nix) ];
    };

    python-env = pkgs.python2.buildEnv.override (with pkgs.python2Packages; {
      extraLibs = [ rosdistro matplotlib h5py ];
      ignoreCollisions = true;
    });

in pkgs.mkShell rec {
  name = "ROS-D";

  buildInputs = with pkgs; [
    python-env
    python2Packages.rosdep
    python2Packages.rosinstall-generator
    catkin

    # Message Generation Packages
    genmsg gencpp genpy geneus genlisp gennodejs

    # Messages
    std_msgs geometry_msgs sensor_msgs actionlib_msgs nav_msgs map_msgs
    rosgraph_msgs trajectory_msgs control_msgs diagnostic_msgs
    shape_msgs stereo_msgs visualization_msgs common_msgs tf2_msgs

    # General Modules
    rosclean console_bridge cpp_common rostime
    rosunit rosconsole rosconsole_bridge rosmsg
    roscpp_core roscpp_traits roscpp_serialization
    message_generation message_runtime roslang
    xmlrpcpp rosgraph roscpp roscpp_tutorials
    ros_environment roslz4 std_srvs cmake_modules
    rospack rosbash roslib rosmaster
    rospy rosparam rosout roslaunch
    rostest topic_tools rosbag_storage rosbag
    actionlib ros_core ros_base class_loader
    pluginlib rosbag_migration_rule rostopic
    rosnode rosservice rosbuild roswtf
    message_filters angles tf2 tf2_py tf2_ros tf
    image_transport resource_retriever
    laser_geometry interactive_markers interactive_marker_tutorials
    media_export python_qt_binding
    urdfdom_headers urdf_parser_plugin urdfdom urdf
    rviz
  ];
  
  # To use rosdep without sudo, environment variable needs to be
  # set. For example
  #
  # ROSDEP_SOURCE_PATH=/home/breakds/Downloads/ros_root
  #
  # This is already done in shellHook
  shellHook = ''
      export ROSDEP_SOURCE_PATH=$HOME/Downloads/ros_root
      mkdir -p $HOME/Downloads/ros_root
      export PS1="$(echo -e '\uf544')  {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
  '';
}
