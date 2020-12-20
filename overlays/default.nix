self: super:

let old-jetbrains-nixpkgs = import (builtins.fetchTarball {
      url = https://github.com/NixOS/nixpkgs/tarball/83c627b8b0e40d14aed0b02ecb3c303444152a8b;
    }) { config.allowUnfree = true; };

    unstablePkgs = import (builtins.fetchTarball {
      # 2020 July 22
      url = https://github.com/NixOS/nixpkgs/tarball/af5765b0dc424341c19a14bfbca5b98f6157cb75;
    }) { config.allowUnfree = true; };

    pythonOverride = {
      packageOverrides = python-self: python-super: {
        jupyterlab_server = python-self.callPackage ./python/jupyterlab_server.nix {};
        jupyterlab = python-self.callPackage ./python/jupyterlab.nix {};
        pytorch = python-self.callPackage ../pkgs/temp/pytorch {
          cudaSupport = false;
          oneDNN = unstablePkgs.oneDNN;
          blas = unstablePkgs.blas;
        };
        pytorchWithoutCuda = python-self.pytorch;
        pytorchWithCuda = python-self.pytorch.override {
          cudaSupport = true;
        };
      };
    };

in {
  # LLVM series
  inherit (super.llvmPackages_11) clang libclang llvm;

  # Python package overrides.
  python3 = super.python3.override pythonOverride;

  # termite the terminal emulator, with my own configuration
  termite = self.callPackage ./termite.nix {
    termiteBasePackage = super.termite;
    config = {
      font-face = "Monospace";
      font-size = 10;
      scrollback = 25000;
    };
  };

  patchedHostname = self.callPackage ./hostname {
    inherit (super) nettools;
  };

  ros2nix = self.callPackage ../pkgs/ros/tools/ros2nix {};

  gperftools = self.callPackage ./gperftools.nix {};

  cudatoolkit = super.cudatoolkit_10;

  web-dev-tools = self.callPackage ../pkgs/web-dev-tools {};
  py-dev-tools = self.callPackage ../pkgs/py-dev-tools {};

  # Override the jetbrains with an older version, where clion supports bazel.
  old-jetbrains = old-jetbrains-nixpkgs.jetbrains;

  # www.breakds.org, the personal website
  www-breakds-org = self.callPackage ../pkgs/www-breakds-org {};

  # This is for nixvital-reflection service, a web page to list
  # current highlighted NixOS variable/value pairs.
  simple-reflection-server = self.callPackage ../pkgs/simple-reflection-server {};

  # Customized texlive
  breakds-texlive =  super.texlive.combine {
    inherit (super.texlive) collection-basic collection-latex collection-latexextra
      collection-latexrecommended collection-fontsrecommended collection-langchinese collection-langcjk collection-metapost
      collection-bibtexextra newlfm;
  };

  # Web-based Visual Studio Code
  code-server = self.callPackage ../pkgs/code-server {
    nodejs = super.nodejs-12_x;
  };

  # Need this for hugo 0.74
  hugo = unstablePkgs.hugo;

  ethminer = super.ethminer.override {
    stdenv = self.clangStdenv;
  };
  
  # WebAssembly Toolchain
  # FIXME: Re-enable these when llvm 11 comes out
  # binaryen = self.callPackage ../pkgs/compilers/binaryen {};
  # emscripten = self.callPackage ../pkgs/compilers/emscripten {};
}
