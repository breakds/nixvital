# For development of this package, run
#
#   nix-build -E "with import <nixpkgs> {}; callPackage ./default.nix {}"

{ stdenv, pkgs, makeWrapper, ... }:

let python = pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
      click
      tabulate
      prompt_toolkit
    ]);

in stdenv.mkDerivation {
  name = "py_dev_tools";
  srcs = ./srcs;
  buildInputs = [ python makeWrapper ];

  unpackPhase = ":";
  buildPhase = ":";
  
  installPhase = ''
    mkdir -p $out/lib
    cp -r $srcs/shell $out/lib

    mkdir -p $out/bin
    cp $srcs/py_lorri.py $out/bin/py_lorri
    chmod +x $out/bin/py_lorri
    
    wrapProgram $out/bin/py_lorri \
      --add-flags --shell_library=$out/lib/shell
  '';
}
