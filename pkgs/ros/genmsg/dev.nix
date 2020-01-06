with import <nixpkgs> {};

let ros-base = pkgs.callPackage ../base {};

    buildRosPackage = pkgs.callPackage ../build.nix {
      inherit (ros-base) ros-python catkin;
    };

in pkgs.callPackage ./default.nix {
  inherit buildRosPackage;
}
