{ pkgs, lib }:

pkgs.python3Packages.buildPythonApplication rec {
  pname = "nixvital-web-installer";
  version = "0.4.0";

  src = pkgs.fetchgit {
    url = "https://github.com/breakds/nixvital-web-installer.git";
    rev = "0.4.0";
    sha256 = "0bgyam90i798f3fn9mr16h8wzpbvcz35i82mi2h6j1x6zxf40r1s";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    click flask psutil GitPython pyyaml
  ];
}
