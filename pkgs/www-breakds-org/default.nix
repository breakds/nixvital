{ stdenv, pkgs, hugo, ... }:

stdenv.mkDerivation {
  name = "www-breakds-org";
  
  src = pkgs.fetchgit {
    url = "https://github.com/breakds/www.breakds.org.git";
    rev = "0cabd3d86a8bc524e896be0d58d207144f66dc3d";
    sha256 = "sha256-gfJoGJcYh4XWAvGLMSXjUKqy4Q+D1Uqzj+rL9y9nn/A=";
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
