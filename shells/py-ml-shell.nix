{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

# Ucomment to get packages from unstable
# let unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {
#       config.allowUnfree = true;
#     };

let python = pkgs.python37.withPackages (python-packages: with python-packages; [
      pip
      numpy

      # Frameworks
      lightgbm
      pytorchWithCuda
    ]);

in pkgs.mkShell rec {
  name = "py-ml-shell";
  buildInputs = [ python ];
  shellHook = ''
    export PS1="$(echo -e '\uf3e2') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
  '';
}
