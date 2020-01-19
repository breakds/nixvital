# For development of this package, run
#
#   nix-build -E "with import <nixpkgs> {}; callPackage ./default.nix {}"

{ stdenv, pkgs, ... }:

let python = pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
      flask
    ]);

in stdenv.mkDerivation {
  name = "bds-public-web";
  srcs = ./srcs;
  buildInputs = [ python ];

  unpackPhase = ":";
  buildPhase = ":";
  
  installPhase = ''
    mkdir -p $out/bin
    cp $srcs/basic_page.py $out/bin/basic_page
    chmod +x $out/bin/basic_page
  '';
}
