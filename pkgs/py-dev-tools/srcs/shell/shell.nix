# { pkgs ? import <nixpkgs> {
#   config.allowUnfree = true;
#   overlays = [ (import ./overlays.nix) ];
# } }:

let pkgs = import <nixpkgs> {};

    extraPackages = with pkgs.python3Packages; rec {
      dash-html-components = callPackage ./.shell.d/dash-html-components.nix {};
      dash-core-components = callPackage ./.shell.d/dash-core-components.nix {};
      dash-renderer = callPackage ./.shell.d/dash-renderer.nix {};
      dash-table = callPackage ./.shell.d/dash-table.nix {};
      percy = callPackage ./.shell.d/percy.nix {};
      dash = callPackage ./.shell.d/dash.nix {
        inherit dash-html-components dash-renderer dash-table dash-core-components percy;
      };
    };

    python = pkgs.python3.withPackages (python-packages: with python-packages; [
      # Base
      numpy
      pandas
      matplotlib
      plotly
      # extraPackages.dash

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
