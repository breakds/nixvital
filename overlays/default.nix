self: super:

{
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

  # alacritty the terminal emulator, customized version
  alacritty = self.callPackage ./alacritty.nix {
    basePackage = super.alacritty;
    customize = {
      font-size = 7.0;
      font-face = "Fira Code";
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

  cudatoolkit = super.cudatoolkit_10;

  nixvital-shell-accessors = self.callPackage ./nixvital-shell-accessors {};
}
