# nix-build -E "with (import <nixpkgs/nixos> {}).pkgs; callPackage ./reducer.nix {}"
{ stdenv, cmake, catkin, roscpp, gflags }:

let pname = "toy-ros-reducer";
    version = "1.0.0";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  nativeBuildInputs = [ cmake catkin roscpp gflags ];

  srcs = builtins.fetchGit {
    url = "https://git.breakds.org/experimental/toy-ros-reducer.git";
    ref = "v1.0.1";
    # Or, specify the commit ID with rev
    # rev = "ce95e6b651cf17575a178813adcda3494a960196";
  };
}
