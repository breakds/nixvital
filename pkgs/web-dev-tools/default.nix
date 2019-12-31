# For development of this package, run
#
#   nix-build -E "with import <nixpkgs> {}; callPackage ./default.nix {}"

{ stdenv, pkgs, ... }:

let python = pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
      tabulate
      prompt_toolkit
    ]);

in stdenv.mkDerivation {
  name = "web_dev_tools";
  srcs = ./srcs;
  buildInputs = [ python ];

  unpackPhase = ":";
  buildPhase = ":";
  
  installPhase = ''
    mkdir -p $out/bin
    cp $srcs/web_dev_init.py $out/bin/web_dev_init
    chmod +x $out/bin/web_dev_init
  '';
}
