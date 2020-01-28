{ stdenv, pkgs, hugo, ... }:

stdenv.mkDerivation {
  name = "www-personal";
  
  src = pkgs.fetchgit {
    url = "https://github.com/breakds/www.breakds.org.git";
    rev = "e3ee7a134b6df6388385933befc3025cf36bae30";
    sha256 = "1ywlj2my262i2nz4nh0q1xha08yyn65pi2kbx8bxb3gjnsy5mpmb";
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
