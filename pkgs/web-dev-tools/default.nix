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
    cp $srcs/nvm_lorri.py $out/bin/nvm_lorri
    chmod +x $out/bin/nvm_lorri
  '';
}
