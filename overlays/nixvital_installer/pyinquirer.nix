{ lib, buildPythonPackage, fetchPypi, pytest,
  prompt_toolkit, ... }:

buildPythonPackage rec {
  pname = "PyInquirer";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lgfdlv0vabbhfzmrgqiq9fkwxz9v67w023rda4bszvjsxl2vaf9";
  };

  propagatedBuildInputs = [ prompt_toolkit ];

  doCheck = false;
  
  meta = {
    homepage = "https://github.com/CITGuru/PyInquirer/";
    description = "A collection of common interactive command line user interfaces.";
    license = lib.licenses.mit;
  };
}
