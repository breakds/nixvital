# See https://discourse.nixos.org/t/how-to-add-custom-python-package/536/3
# And https://github.com/NixOS/nixpkgs/pull/54266#issuecomment-455592425

{ pkgs ? import <nixpkgs> {
  config.allowUnfree = true;
} }:

let extraPackages = with pkgs.python27Packages; rec {
      empy = callPackage ./py/empy.nix {};
      catkin-pkg = callPackage ./py/catkin-pkg.nix {};
      rospkg = callPackage ./py/rospkg.nix {
        inherit catkin-pkg;
      };
    };
    
    python = pkgs.python27.withPackages (python-packages: with python-packages; [
      extraPackages.empy
      extraPackages.rospkg
      extraPackages.catkin-pkg
    ]);

  in pkgs.mkShell rec {
    name = "ROS-D";
    buildInputs = [ python ];
    shellHook = ''
      export PS1="$(echo -e '\uf544') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
  '';
  }
