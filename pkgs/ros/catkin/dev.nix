with import <nixpkgs> {};

let extraPackages = with pkgs.python2Packages; rec {
      catkin-pkg = callPackage ../py/catkin_pkg {};
      rospkg = callPackage ../py/rospkg { inherit catkin-pkg; };
    };

    empy = pkgs.python2Packages.callPackage ../py/empy {};
    
in callPackage ./default.nix {
  inherit (extraPackages) catkin-pkg rospkg;
  inherit empy;
}
