{ stdenv, pkgs, fetchFromGitHub, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  pname = "simple-reflection-server";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "breakds";
    repo = pname;
    rev = version;
    sha256 = "1cjqilkdb5xhf7rmyffcg6baqxhrcjfrm0q4ddgwpc5w0960nld8";
  };

  cargoSha256 = "1jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj";
  verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "Nothing fancy, just show the key:value pairs it asks to show on a web page.";
    homepage = https://github.com/breakds/simple-reflection-server;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
