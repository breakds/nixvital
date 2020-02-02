{ stdenv, pkgs, fetchFromGitHub, ... }:

let mkRustPlatform = pkgs.callPackage ../build-tools/mk-rust-platform.nix {};

    rustPlatform = mkRustPlatform {
      date = "2020-01-15";
      channel = "nightly";
    };

in rustPlatform.buildRustPackage rec {
  pname = "simple-reflection-server";
  version = "1.1.x";

  src = fetchFromGitHub {
    owner = "breakds";
    repo = pname;
    rev = version;
    sha256 = "1y2irlnha0dj63zp3dfbmrhssjj9qdxcl7h5sfr5nxf6dd4vjccg";
  };

  # FIXME: This is a hack that should be removed in the future.
  #
  # Cargo needs $HOME to do some work but buildRustPackage did not
  # handle that. Cheating by give it a temporary directory as home.
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
