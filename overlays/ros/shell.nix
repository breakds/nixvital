let pkgs = import <nixpkgs> {
      config.allowUnfree = true;
      overlays = [ (import ./default.nix) ];
    };

    python-env = pkgs.python2.withPackages (ps: [
      ps.rosdistro
    ]);

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
  ];
  
  # buildInputs = with pkgs; [ ros-essential.all genmsg gencpp genpy geneus gennodejs genlisp
  #                            rosclean console_bridge cpp_common
  #                            rostime rosunit rosconsole
  #                            rosconsole_bridge rosmsg
  #                            roscpp_core roscpp_traits roscpp_serialization
  #                            message_generation message_runtime
  #                            roslang xmlrpcpp
  #                            std_msgs rosgraph_msgs geometry_msgs sensor_msgs actionlib_msgs
  #                            nav_msgs map_msgs
  #                            roscpp roscpp_tutorials
  #                            ros_environment roslz4 rosgraph
  #                            std_srvs cmake_modules rospack rosbash roslib
  #                            rospy rosmaster rosparam rosout roslaunch rostest
  #                            topic_tools rosbag_storage rosbag
  #                            actionlib ros_core ros_base class_loader pluginlib
  #                            rosbag_migration_rule trajectory_msgs control_msgs
  #                            diagnostic_msgs shape_msgs stereo_msgs visualization_msgs common_msgs
  #                            rostopic rosnode rosservice rosbuild roswtf tf2_msgs message_filters
  #                            angles tf2 tf2_py tf2_ros tf image_transport resource_retriever
  #                          ];

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
