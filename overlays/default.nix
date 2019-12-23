self: super:

let old-jetbrains-nixpkgs = import (builtins.fetchTarball {
      url = https://github.com/NixOS/nixpkgs/tarball/1b3c024157748cbab30a6200aa6b1496cefa787b;
      sha256 = "0ry2rzx9126lmifmdv12p2n3a5p0crf28g7p1iv1gqxd7n6b2rga";
    }) { config.allowUnfree = true; };

in {
  # LLVM series
  inherit (super.llvmPackages_8) clang libclang llvm;

  # termite the terminal emulator, with my own configuration
  termite = self.callPackage ./termite.nix {
    termiteBasePackage = super.termite;
    config = {
      font-face = "Monospace";
      font-size = 10;
      scrollback = 25000;
    };
  };

  # Arcanist demand the existence of cpplint.py, so we need to create
  # a softlink to cpplint to applease it.
  cpplint = self.callPackage ./cpplint.nix {
    cpplintBasePackage = super.cpplint;
  };

  patchedHostname = self.callPackage ./hostname {
    inherit (super) nettools;
  };

  gperftools = self.callPackage ./gperftools.nix {};

  cudatoolkit = super.cudatoolkit_10;

  nixvital-shell-accessors = self.callPackage ./nixvital-shell-accessors {};

  # Override the jetbrains with an older version, where clion supports bazel.
  jetbrains = old-jetbrains-nixpkgs.jetbrains;
}
