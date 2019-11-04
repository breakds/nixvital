{ stdenv, lib, ... }:

stdenv.mkDerivation rec {
  name = "nixvital-shell-accessors";
  srcs = ./scripts;

  buildInputs = [];

  unpackPhase = ":";
  buildPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    for f in $(ls $srcs); do
      install -m 555 $srcs/$f $out/bin/''${f%.*}
    done
    echo "[done]"
  '';
}
