{ stdenv, pkgs, makeWrapper, nix, ... }:

let python = pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
      click
      pyyaml
      prompt_toolkit
    ]);

    package_list = ./srcs/kinetic_packages.yaml;

in stdenv.mkDerivation {
  name = "ros2nix";
  srcs = ./srcs;

  buildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ nix python ];

  unpackPhase = ":";
  buildPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cp $srcs/ros2nix.py $out/bin/ros2nix
    chmod +x $out/bin/ros2nix

    wrapProgram $out/bin/ros2nix \
      --add-flags --package_list=${package_list}
  '';
}
