{ pkgs ? import <nixpkgs> {
  config.allowUnfree = true;
} }:

with pkgs; with python27Packages;
  let empy = callPackage ./py/empy.nix {};
      python = pkgs.python27.withPackages (python-packages: with python-packages; [
        empy
      ]);

  in pkgs.mkShell rec {
    name = "ROS-D";
    buildInputs = [ python ];
    shellHook = ''
      export PS1="$(echo -e '\uf544') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
  '';
  }
