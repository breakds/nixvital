# See https://discourse.nixos.org/t/how-to-add-custom-python-package/536/3
# And https://github.com/NixOS/nixpkgs/pull/54266#issuecomment-455592425

# The package ros-base is a combination of
#
# 1. A python environment with required ROS packages.
# 2. catkin, the CMake based ROS build system
# 3. rosdep/rosinstall, the tools for finding out ROS modules.

{ pkgs, ... }:

let extraPackages = with pkgs.python2Packages; rec {
      catkin-pkg = callPackage ../py/catkin_pkg {};
      rospkg = callPackage ../py/rospkg { inherit catkin-pkg; };

      # For ROS standard installation only, which means that they are
      # not necessary for building the actual packages.
      rosdistro = callPackage ../py/rosdistro {
        inherit catkin-pkg rospkg;
      };
    };

    rosdep = pkgs.python2Packages.callPackage ../py/rosdep {
      inherit (extraPackages) rospkg rosdistro;
    };

    rosinstall-generator = pkgs.python2Packages.callPackage ../py/rosinstall_generator {
      inherit (extraPackages) rosdistro;
    };

    empy = pkgs.python2Packages.callPackage ../py/empy {};
    
    ros-python = pkgs.python27.withPackages (python-packages: with python-packages; [
      numpy
      setuptools
      extraPackages.rospkg
      extraPackages.catkin-pkg
    ]);

    catkin = pkgs.callPackage ../catkin {
      inherit (extraPackages) catkin-pkg rospkg;
      inherit empy;
    };

in {
  inherit (extraPackages) catkin-pkg rospkg;
  inherit ros-python catkin;
    
  all = pkgs.symlinkJoin rec {
    name = "ros-base";
    paths = [ ros-python rosdep rosinstall-generator catkin ];
  };
}
