{ stdenv, pkgs, fetchFromGitHub, ... }:

let mkRustPlatform = pkgs.callPackage ../build-tools/mk-rust-platform.nix {};

    rustPlatform = mkRustPlatform {
      date = "2019-06-01";
      channel = "nightly";
    };

in rustPlatform.buildRustPackage rec {
  # pname = "simple-reflection-server";
  # version = "1.1";

  # src = fetchFromGitHub {
  #   owner = "breakds";
  #   repo = pname;
  #   rev = version;
  #   sha256 = "1cjqilkdb5xhf7rmyffcg6baqxhrcjfrm0q4ddgwpc5w0960nld8";
  # };

  name = "simple-reflection-server";

  src = pkgs.fetchgit {
    url = "https://github.com/breakds/simple-reflection-server.git";
    rev = "6194f931635c2210b78f9a497fe59b053dab09c6";
    sha256 = "0ap5y7j990qnicgzn9vnp1vv5bg10wvbr9pr1jghd0drzii21xcy";
  };

  preConfigure = ''
    export HOME=$(mktemp -d)
  '';

  cargoSha256 = "0drf5xnqin26zdyvx9n2zzgahcnrna0y56cphk2pb97qhpakvhbj";
  verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "Nothing fancy, just show the key:value pairs it asks to show on a web page.";
    homepage = https://github.com/breakds/simple-reflection-server;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
