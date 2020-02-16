# For development of this package, run
#
#   nix-build -E "with import <nixpkgs> {}; callPackage ./default.nix {}"

{ stdenv, pkgs, symlinkJoin, ... }:

let python = pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
      tabulate
      prompt_toolkit
    ]);

    nvm_lorri = stdenv.mkDerivation {
      name = "nvm_lorri";
      srcs = ./srcs;
      buildInputs = [ python ];

      unpackPhase = ":";
      buildPhase = ":";
      
      installPhase = ''
        mkdir -p $out/bin
        cp $srcs/nvm_lorri.py $out/bin/nvm_lorri
        chmod +x $out/bin/nvm_lorri
      '';
    };

    webdev = pkgs.writeShellScriptBin "webdev" ''
      target_dir=$(pwd)
      shell_nix=$target_dir/shell.nix
      if [ ! -f "$shell_nix" ]; then
        cp ${toString ../../shells/webdev/shell.nix} $shell_nix
      fi
      nix-shell $shell_nix
    '';

in pkgs.symlinkJoin {
  name = "web-devl-tools";
  buildInputs = [ nvm_lorri webdev ];
  paths = [ nvm_lorri webdev ];
}
