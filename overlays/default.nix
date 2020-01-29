self: super:

let old-jetbrains-nixpkgs = import (builtins.fetchTarball {
      url = https://github.com/NixOS/nixpkgs/tarball/83c627b8b0e40d14aed0b02ecb3c303444152a8b;
    }) { config.allowUnfree = true; };

    backportPkgs = import (builtins.fetchTarball {
      # 2020 Jan 26
      url = https://github.com/NixOS/nixpkgs/tarball/05e661f665047984189b96c724f5a5a1745ec7cb;
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

  ros2nix = self.callPackage ../pkgs/ros/tools/ros2nix {};

  gperftools = self.callPackage ./gperftools.nix {};

  cudatoolkit = super.cudatoolkit_10;

  web-dev-tools = self.callPackage ../pkgs/web-dev-tools {};
  py-dev-tools = self.callPackage ../pkgs/py-dev-tools {};

  # Override the jetbrains with an older version, where clion supports bazel.
  old-jetbrains = old-jetbrains-nixpkgs.jetbrains;

  # Backport the newer version of hugo
  hugo = backportPkgs.hugo;

  # www.breakds.org, the personal website
  www-breakds-org = self.callPackage ../pkgs/www-breakds-org {};
}
