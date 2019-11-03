{ pkgs ? import <nixpkgs> {} }:

let python = pkgs.python37.withPackages (python-packages: with python-packages; [
      pip
      numpy

      # Frameworks
      lightgbm
      pytorch
    ]);

in pkgs.mkShell rec {
  name = "py-ml-shell";
  buildInputs = [ python ];
  shellHook = ''
    export PS1="$(echo -e '\uf3e2') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
  '';
}
