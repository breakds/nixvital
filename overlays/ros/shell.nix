let pkgs = import <nixpkgs> {
      config.allowUnfree = true;
      overlays = [ (import ./default.nix) ];
    };

in pkgs.mkShell rec {
  name = "ROS-D";
  
  buildInputs = with pkgs; [ ros-base.all genmsg gencpp genpy geneus gennodejs genlisp
                             rosclean console_bridge cpp_common
                             rostime rosunit rosconsole
                             rosconsole_bridge rosmsg
                             roscpp_core roscpp_traits roscpp_serialization
                             message_generation message_runtime
                             roslang xmlrpcpp
                             std_msgs rosgraph_msgs geometry_msgs sensor_msgs actionlib_msgs
                             nav_msgs map_msgs
                             roscpp roscpp_tutorials
                             ros_environment roslz4 rosgraph
                             std_srvs cmake_modules rospack rosmaster
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
