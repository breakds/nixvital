with import <nixpkgs> {};

let ros-base = pkgs.callPackage ../base {};

    buildRosPackage = pkgs.callPackage ../build.nix {
      inherit (ros-base) ros-python catkin;
    };

    genmsg = pkgs.callPackage ../genmsg {
      inherit buildRosPackage;
    };

in pkgs.callPackage ./default.nix {
  inherit buildRosPackage genmsg;
}
