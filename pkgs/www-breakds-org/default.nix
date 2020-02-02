{ stdenv, pkgs, hugo, ... }:

stdenv.mkDerivation {
  name = "www-breakds-org";
  
  src = pkgs.fetchgit {
    url = "https://github.com/breakds/www.breakds.org.git";
    rev = "32b292ab095c5f08fc2d78af3d649a01ed3599d2";
    sha256 = "1kl5vpd7jl6rkq7akq6140789sqp1gnwxaaz7hp9jkv49zn2hgay";
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
