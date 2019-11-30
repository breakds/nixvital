{ pkgs ? import <nixpkgs> {
  config.allowUnfree = true;
  overlays = [ (import ./overlays.nix) ];
} }:

let extraPackages = with pkgs.python38Packages; rec {
      dash-html-components = callPackage ./dash-html-components.nix {};
      dash-core-components = callPackage ./dash-core-components.nix {};
      dash-renderer = callPackage ./dash-renderer.nix {};
      dash-table = callPackage ./dash-table.nix {};
      percy = callPackage ./percy.nix {};
      dash = callPackage ./dash.nix {
        inherit dash-html-components dash-renderer dash-table dash-core-components percy;
      };
      ipympl = callPackage ./ipympl.nix {};
      python-nodejs = callPackage ./python-nodejs.nix {};
    };

    python = pkgs.python38.withPackages (python-packages: with python-packages; [
      # Base
      pip
      numpy
      matplotlib
      plotly
      extraPackages.dash

      # ---------- Frameworks ----------
      lightgbm
      # pytorchWithCuda

      # ---------- Tools ----------
      jupyterlab
    ]);

in pkgs.mkShell rec {
  name = "pyd";
  buildInputs = [ python ];
  shellHook = ''
    export PS1="$(echo -e '\uf3e2') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
  '';
}
