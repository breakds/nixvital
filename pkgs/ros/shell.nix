# See https://discourse.nixos.org/t/how-to-add-custom-python-package/536/3
# And https://github.com/NixOS/nixpkgs/pull/54266#issuecomment-455592425

{ pkgs ? import <nixpkgs> {
  config.allowUnfree = true;
} }:

let ros-base = pkgs.callPackage ./base {};

    buildRosPackage = pkgs.callPackage ./build.nix {
      inherit (ros-base) ros-python catkin;
    };

    # +------------------------------------------------------------+
    # | Official ROS modules                                       |
    # +------------------------------------------------------------+

    genmsg = pkgs.callPackage ./genmsg {
      inherit buildRosPackage;
    };

    gencpp = pkgs.callPackage ./gencpp {
      inherit buildRosPackage genmsg;
    };

    genpy = pkgs.callPackage ./genpy {
      inherit buildRosPackage genmsg;
    };

    rosclean = pkgs.callPackage ./rosclean {
      inherit buildRosPackage;
    };

in pkgs.mkShell rec {
  name = "ROS-D";
  
  buildInputs = [ ros-base.all genmsg gencpp genpy rosclean ];
  
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
