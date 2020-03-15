{ pkgs, lib }:

pkgs.python3Packages.buildPythonApplication rec {
  pname = "nixvital-web-installer";
  version = "0.3.1";

  src = pkgs.fetchgit {
    url = "https://github.com/breakds/nixvital-web-installer.git";
    rev = "65bc629fc0740a21197b8b6c1032b6187ec0afa1";
    sha256 = "1n8wcna31hf9zx22bpqwr3bbylflil2293cb5ccrhmq108brx08l";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    click flask psutil GitPython
  ];
}
