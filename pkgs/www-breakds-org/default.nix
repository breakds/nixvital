{ stdenv, pkgs, hugo, ... }:

stdenv.mkDerivation {
  name = "www-personal";
  
  src = pkgs.fetchgit {
    url = "https://github.com/breakds/www.breakds.org.git";
    rev = "11dba588380596704c08249c92cad522f5b038a3";
    sha256 = "1fhgvdmyvkdmbj0sphmki70j3qlvlv8fav2zhj9j0aq4fmzhcifk";
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
