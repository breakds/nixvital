# nix-build -E "with (import <nixpkgs/nixos> {}).pkgs; callPackage ./producer.nix {}"
{ stdenv, cmake, catkin, roscpp, gflags }:

let pname = "toy-ros-producer";
    version = "1.0.0";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  nativeBuildInputs = [ cmake catkin roscpp gflags ];

  srcs = builtins.fetchGit {
    url = "https://git.breakds.org/experimental/toy-ros-producer.git";
    # ref = "v1.0.0";
    # Or, specify the commit ID with rev
    rev = "206741c2ac69d6a5a122626ca26b58667748a292";
  };
}
