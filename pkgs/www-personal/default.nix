{ stdenv, pkgs, hugo, ... }:

stdenv.mkDerivation {
  name = "www-personal";
  
  src = pkgs.fetchgit {
    url = "https://github.com/breakds/www.breakds.org.git";
    rev = "eeaa9bac9b8ab992eff614462646bbc3dfdee34d";
    sha256 = "1q7f50cg3h286w2fb7k33zb60hy8vyfw6sgjdf2v6f9jmdps77kn";
    fetchSubmodules = true;
  };

  # NOTE(breakds): This repo uses academic theme, which requries hugo
  # with version > 0.60.
  buildInputs = [ hugo ];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  unpackPhase = ":";

  buildPhase = ''
    cd $src
    ${hugo}/bin/hugo
  '';

  installPhase = ''
    mkdir -p $out
    cp -r $src/public/* $out
  '';
}
