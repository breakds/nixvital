{ stdenv, lib, callPackage, symlinkJoin, nettools, makeWrapper, ... }:

stdenv.mkDerivation rec {
  name = "patched_hostname";
  src = ./hostname_frontend.cc;
  buildInputs = [ nettools makeWrapper ];
  unpackPhase = ":";
  buildPhase = ''
    g++ $src -o hostname_frontend
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp hostname_frontend $out/bin/hostname
    wrapProgram $out/bin/hostname \
        --add-flags ${nettools}/bin/hostname
    echo "[done] Build ${name}"
  '';
}
