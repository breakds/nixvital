{ stdenv, pkgs, hugo, ... }:

stdenv.mkDerivation {
  name = "www-personal";
  
  src = pkgs.fetchgit {
    url = "https://github.com/breakds/www.breakds.org.git";
    rev = "36e8c305df2cb3b2384512db0552af8b5e993a20";
    sha256 = "0agdfc6cvm41x9f6248fqwfrs15lan6b51rvzmfcigqk8y3l1kjv";
    fetchSubmodules = true;
  };

  # NOTE(breakds): This repo uses academic theme, which requries hugo
  # with version > 0.60.
  buildInputs = [ hugo ];

  buildPhase = ''
    hugo
  '';

  installPhase = ''
    cp -r public $out
  '';
}
