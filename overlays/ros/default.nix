self: super:

{
  ros-base = self.callPackage ../../pkgs/ros/base/default.nix {};
  
  buildRosPackage = self.callPackage ../../pkgs/ros/build.nix {
    inherit (self.ros-base) ros-python catkin;
  };

  python-rospkg = self.ros-base.rospkg;
  python-rosdep = self.ros-base.rosdep;
  python-catkin-pkg = self.ros-base.catkin-pkg;
  python-netifaces = self.python2Packages.netifaces;
  python-numpy = self.python2Packages.numpy;
  python-yaml = self.python2Packages.pyyaml;
  python-defusedxml = self.python2Packages.defusedxml;
  python-paramiko = self.python2Packages.paramiko;
  python-imaging = self.python2Packages.pillow;

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
}
