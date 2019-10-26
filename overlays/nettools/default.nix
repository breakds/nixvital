{ stdenv, lib, callPackage, symlinkJoin, nettools, makeWrapper, ... }:

let hostname_frontend = stdenv.mkDerivation {
      name = "hostname_frontend";
      src = ./hostname_frontend.cc;
      unpackPhase = ":";
      buildPhase = ''
        g++ $src -o hostname_frontend
      '';
      installPhase = ''
        mkdir -p $out/bin
        cp hostname_frontend $out/bin
      '';
    };

in symlinkJoin {
  name = "nettools";
  paths = [ nettools hostname_frontend ];
  buildInputs = [ nettools makeWrapper ];
  postBuild = ''
    echo $out
    mv $out/bin/hostname $out/bin/real_hostname
    ln -s $out/bin/hostname_frontend $out/bin/hostname
    wrapProgram $out/bin/hostname --add-flags $out/bin/real_hostname
    echo "[done] build"
  '';
}
