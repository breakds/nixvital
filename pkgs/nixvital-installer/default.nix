{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "nixvital-installer";
  version = "1.0.0";

  srcs = ./srcs;

  propagatedBuildInputs = with python3Packages; [
    clint click cement
    tabulate GitPython prompt_toolkit
    pygments
  ];
}
