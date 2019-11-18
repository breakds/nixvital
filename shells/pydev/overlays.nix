self: super:

let unstable-tarball = builtins.fetchTarball {
      url = https://github.com/NixOS/nixpkgs/tarball/4eed2a56e6a512b184bb614ebfd26658ed11eef4;
      # url = https://github.com/NixOS/nixpkgs-channels/archive/nixpkgs-unstable.tar.gz;
      sha256 = "1bbkqn0q6mc1qshb2v2a78bf745x50a830i15fg1gfwg9qq5j8aq";
    };

in {
  nixpkgs-unstable = import unstable-tarball {
    config.allowUnfree = true;
  };

  # +--------------------+
  # | Python Packages    |
  # +--------------------+

  python38 = self.nixpkgs-unstable.python38;
  python38Packages = self.nixpkgs-unstable.python38Packages;
  python38Full = self.nixpkgs-unstable.python38Full;

  python37 = self.nixpkgs-unstable.python37;
  python37Packages = self.nixpkgs-unstable.python37Packages;
  python37Full = self.nixpkgs-unstable.python37Full;
}
