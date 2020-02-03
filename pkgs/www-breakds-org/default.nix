{ stdenv, pkgs, hugo, ... }:

stdenv.mkDerivation {
  name = "www-breakds-org";
  
  src = pkgs.fetchgit {
    url = "https://github.com/breakds/www.breakds.org.git";
    rev = "6f8593616c34428a30013375889f4cc3ca0d15e9";
    sha256 = "1zf5qh7il0bp0jz3vv5k8bdlv6jiijvnc0605ak5jjsi9lrgg28a";
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
