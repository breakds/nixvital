{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

# Ucomment to get packages from unstable
# let unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {
#       config.allowUnfree = true;
#     };

let extraPackages = with pkgs.python37Packages; rec {
      dash-html-components = callPackage ./dash-html-components.nix {};
      dash-core-components = callPackage ./dash-core-components.nix {};
      dash-renderer = callPackage ./dash-renderer.nix {};
      dash-table = callPackage ./dash-table.nix {};
      percy = callPackage ./percy.nix {};
      dash = callPackage ./dash.nix {
        inherit dash-html-components dash-renderer dash-table dash-core-components percy;
      };
    };

    python = pkgs.python37.withPackages (python-packages: with python-packages; [
      # Base
      pip
      numpy
      matplotlib

      # Frameworks
      lightgbm
      # pytorchWithCuda
      extraPackages.dash

      # Tools
      jupyterlab
    ]);

in pkgs.mkShell rec {
  name = "pyd";
  buildInputs = [ python ];
  shellHook = ''
    export PS1="$(echo -e '\uf3e2') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
  '';
}
