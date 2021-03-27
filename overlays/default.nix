self: super:

let unstablePkgs = import (builtins.fetchTarball {
      # 2021 Jan 03
      url = https://github.com/NixOS/nixpkgs/tarball/77d190f10931c1d06d87bf6d772bf65346c71777;
    }) { config.allowUnfree = true; };

    pythonOverride = {
      packageOverrides = python-self: python-super: {
        # Put the customized python packages here.
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

  ros2nix = self.callPackage ../pkgs/ros/tools/ros2nix {};

  cudatoolkit = super.cudatoolkit_10;

  web-dev-tools = self.callPackage ../pkgs/web-dev-tools {};
  py-dev-tools = self.callPackage ../pkgs/py-dev-tools {};

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

  ethminer = super.ethminer.override {
    stdenv = self.clangStdenv;
  };

  terraria-server = unstablePkgs.terraria-server;
  
  # WebAssembly Toolchain
  # FIXME: Re-enable these when llvm 11 comes out
  # binaryen = self.callPackage ../pkgs/compilers/binaryen {};
  # emscripten = self.callPackage ../pkgs/compilers/emscripten {};
}
