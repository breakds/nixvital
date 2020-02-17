{ stdenv, pkgs, hugo, ... }:

stdenv.mkDerivation {
  name = "www-breakds-org";
  
  src = pkgs.fetchgit {
    url = "https://github.com/breakds/www.breakds.org.git";
    rev = "878814d0ca856a6b912f170b7b66a06ea6c7bece";
    sha256 = "022qwganwsxj1w070hb2l2p5vb0g0vvdav5yvf2pcswhjhr5vad2";
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
