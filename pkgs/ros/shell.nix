# See https://discourse.nixos.org/t/how-to-add-custom-python-package/536/3
# And https://github.com/NixOS/nixpkgs/pull/54266#issuecomment-455592425

{ pkgs ? import <nixpkgs> {
  config.allowUnfree = true;
} }:

let extraPackages = with pkgs.python2Packages; rec {
      empy = callPackage ./py/empy {};
      catkin-pkg = callPackage ./py/catkin_pkg {};
      rospkg = callPackage ./py/rospkg { inherit catkin-pkg; };

      # For ROS standard installation only, which means that they are
      # not necessary for building the actual packages.
      rosdistro = callPackage ./py/rosdistro {
        inherit catkin-pkg rospkg;
      };
    };

    # To use rosdep without sudo, environment variable needs to be
    # set. For example
    #
    # ROSDEP_SOURCE_PATH=/home/breakds/Downloads/ros_root
    #
    # This is already done in shellHook
    rosdep = pkgs.python2Packages.callPackage ./py/rosdep {
      inherit (extraPackages) rospkg rosdistro;
    };

    rosinstall-generator = pkgs.python2Packages.callPackage ./py/rosinstall_generator {
      inherit (extraPackages) rosdistro;
    };
    

    python = pkgs.python27.withPackages (python-packages: with python-packages; [
      numpy
      setuptools
      
      extraPackages.empy
      extraPackages.rospkg
      extraPackages.catkin-pkg
    ]);

  in pkgs.mkShell rec {
    name = "ROS-D";
    buildInputs = [ python rosdep rosinstall-generator ];
    shellHook = ''
      export ROSDEP_SOURCE_PATH=$HOME/Downloads/ros_root
      export PS1="$(echo -e '\uf544')  {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
  '';
  }
