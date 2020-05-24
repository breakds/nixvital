{ stdenv, pkgs, hugo, ... }:

stdenv.mkDerivation {
  name = "www-breakds-org";
  
  src = pkgs.fetchgit {
    url = "https://github.com/breakds/www.breakds.org.git";
    rev = "7fb3f4a476edee1f9efbbe30226d4596fa570d98";
    sha256 = "0ckqr041lzfylpvgc579zfryrpxv17wdgnlv1xlahd3j4pa027k7";
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
