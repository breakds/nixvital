self: super:

{
  ros-base = self.callPackage ../../pkgs/ros/base/default.nix {};
  
  buildRosPackage = self.callPackage ../../pkgs/ros/build.nix {
    inherit (self.ros-base) ros-python catkin;
  };

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
  xmlrpcpp = self.callPackage ../../pkgs/ros/xmlrpcpp {};
  rosgraph_msgs = self.callPackage ../../pkgs/ros/rosgraph_msgs {};
  roscpp = self.callPackage ../../pkgs/ros/roscpp {}; # Not finished yet.
}
