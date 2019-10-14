self: super:

{
  # LLVM series
  inherit (super.llvmPackages_7) clang libclang llvm;

  # termite the terminal emulator, with my own configuration
  termite = self.callPackage ./termite.nix {
    termiteBasePackage = super.termite;
    config = {
      font-face = "Monospace";
      font-size = 10;
      scrollback = 25000;
    };
  };
}
