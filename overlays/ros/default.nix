self: super:

let rosPythonEssential = {
      packageOverrides = pyPkgSelf: pyPkgSuper: {
        catkin-pkg = pyPkgSelf.callPackage ../../pkgs/ros/py/catkin_pkg {};
        empy = pyPkgSelf.callPackage ../../pkgs/ros/py/empy {};
        rosdep = pyPkgSelf.callPackage ../../pkgs/ros/py/rosdep {};
        rosdistro = pyPkgSelf.callPackage ../../pkgs/ros/py/rosdistro {};
        rosinstall-generator = pyPkgSelf.callPackage ../../pkgs/ros/py/rosinstall_generator {};
        rospkg = pyPkgSelf.callPackage ../../pkgs/ros/py/rospkg {};
      };
    };

in {
  python27 = super.python27.override rosPythonEssential;
  python36 = super.python36.override rosPythonEssential;
  python37 = super.python37.override rosPythonEssential;

  # This determines which python version to use.
  rosPythonPackages = self.python27.pkgs;

  catkin = self.callPackage ../../pkgs/ros/catkin {};

  buildRosPackage = self.callPackage ../../pkgs/ros/build.nix {};

  genmsg = self.callPackage ../../pkgs/ros/genmsg {};
  gencpp = self.callPackage ../../pkgs/ros/gencpp {};
  genpy = self.callPackage ../../pkgs/ros/genpy {};
  geneus = self.callPackage ../../pkgs/ros/geneus {};
  genlisp = self.callPackage ../../pkgs/ros/genlisp {};
  gennodejs = self.callPackage ../../pkgs/ros/gennodejs {};
  
  rosclean = self.callPackage ../../pkgs/ros/rosclean {};
  console_bridge = self.callPackage ../../pkgs/ros/console_bridge {};
  cpp_common = self.callPackage ../../pkgs/ros/cpp_common {};
  rostime = self.callPackage ../../pkgs/ros/rostime {};
  rosunit = self.callPackage ../../pkgs/ros/rosunit {};
  rosconsole = self.callPackage ../../pkgs/ros/rosconsole {};
  rosconsole_bridge = self.callPackage ../../pkgs/ros/rosconsole_bridge {};
  rosmsg = self.callPackage ../../pkgs/ros/rosmsg {};
  roscpp_core = self.callPackage ../../pkgs/ros/roscpp_core {};
  roscpp_traits = self.callPackage ../../pkgs/ros/roscpp_traits {};
  roscpp_serialization = self.callPackage ../../pkgs/ros/roscpp_serialization {};
  message_generation = self.callPackage ../../pkgs/ros/message_generation {};
  message_runtime = self.callPackage ../../pkgs/ros/message_runtime {};
  roslang = self.callPackage ../../pkgs/ros/roslang {};
  std_msgs = self.callPackage ../../pkgs/ros/std_msgs {};
  geometry_msgs = self.callPackage ../../pkgs/ros/geometry_msgs {};
  sensor_msgs = self.callPackage ../../pkgs/ros/sensor_msgs {};
  actionlib_msgs = self.callPackage ../../pkgs/ros/actionlib_msgs {};
  nav_msgs = self.callPackage ../../pkgs/ros/nav_msgs {};
  map_msgs = self.callPackage ../../pkgs/ros/map_msgs {};
  xmlrpcpp = self.callPackage ../../pkgs/ros/xmlrpcpp {};
  rosgraph_msgs = self.callPackage ../../pkgs/ros/rosgraph_msgs {};
  rosgraph = self.callPackage ../../pkgs/ros/rosgraph {};
  roscpp = self.callPackage ../../pkgs/ros/roscpp {};
  roscpp_tutorials = self.callPackage ../../pkgs/ros/roscpp_tutorials {};
  ros_environment = self.callPackage ../../pkgs/ros/ros_environment {};
  roslz4 = self.callPackage ../../pkgs/ros/roslz4 {};
  std_srvs = self.callPackage ../../pkgs/ros/std_srvs {};
  cmake_modules = self.callPackage ../../pkgs/ros/cmake_modules {};
  rospack = self.callPackage ../../pkgs/ros/rospack {};
  rosbash = self.callPackage ../../pkgs/ros/rosbash {};
  roslib = self.callPackage ../../pkgs/ros/roslib {};  
  rosmaster = self.callPackage ../../pkgs/ros/rosmaster {};
  rospy = self.callPackage ../../pkgs/ros/rospy {};
  rosparam = self.callPackage ../../pkgs/ros/rosparam {};
  rosout = self.callPackage ../../pkgs/ros/rosout {};
  roslaunch = self.callPackage ../../pkgs/ros/roslaunch {};
  rostest = self.callPackage ../../pkgs/ros/rostest {};
  topic_tools = self.callPackage ../../pkgs/ros/topic_tools {};
  rosbag_storage = self.callPackage ../../pkgs/ros/rosbag_storage {};
  rosbag = self.callPackage ../../pkgs/ros/rosbag {};
  actionlib = self.callPackage ../../pkgs/ros/actionlib {};
  ros_core = self.callPackage ../../pkgs/ros/ros_core {};
  ros_base = self.callPackage ../../pkgs/ros/ros_base {};
  class_loader = self.callPackage ../../pkgs/ros/class_loader {};
  pluginlib = self.callPackage ../../pkgs/ros/pluginlib {};
  rosbag_migration_rule = self.callPackage ../../pkgs/ros/rosbag_migration_rule {};
  trajectory_msgs = self.callPackage ../../pkgs/ros/trajectory_msgs {};
  control_msgs = self.callPackage ../../pkgs/ros/control_msgs {};
  diagnostic_msgs = self.callPackage ../../pkgs/ros/diagnostic_msgs {};
  shape_msgs = self.callPackage ../../pkgs/ros/shape_msgs {};
  stereo_msgs = self.callPackage ../../pkgs/ros/stereo_msgs {};
  visualization_msgs = self.callPackage ../../pkgs/ros/visualization_msgs {};
  common_msgs = self.callPackage ../../pkgs/ros/common_msgs {};
  rostopic = self.callPackage ../../pkgs/ros/rostopic {};
  rosnode = self.callPackage ../../pkgs/ros/rosnode {};
  rosservice = self.callPackage ../../pkgs/ros/rosservice {};
  rosbuild = self.callPackage ../../pkgs/ros/rosbuild {};
  roswtf = self.callPackage ../../pkgs/ros/roswtf {};
  tf2_msgs = self.callPackage ../../pkgs/ros/tf2_msgs {};
  message_filters = self.callPackage ../../pkgs/ros/message_filters {};
  angles = self.callPackage ../../pkgs/ros/angles {};
  tf2 = self.callPackage ../../pkgs/ros/tf2 {};
  tf2_py = self.callPackage ../../pkgs/ros/tf2_py {};
  tf2_ros = self.callPackage ../../pkgs/ros/tf2_ros {};
  tf = self.callPackage ../../pkgs/ros/tf {};
  image_transport = self.callPackage ../../pkgs/ros/image_transport {};
  resource_retriever = self.callPackage ../../pkgs/ros/resource_retriever {};
  laser_geometry = self.callPackage ../../pkgs/ros/laser_geometry {};
  interactive_markers = self.callPackage ../../pkgs/ros/interactive_markers {};
  interactive_marker_tutorials = self.callPackage ../../pkgs/ros/interactive_marker_tutorials {};
  media_export = self.callPackage ../../pkgs/ros/media_export {};
}
