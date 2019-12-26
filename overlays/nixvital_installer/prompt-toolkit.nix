{ lib, buildPythonPackage, fetchPypi, pytest,
  ... }:

buildPythonPackage rec {
  pname = "prompt-toolkit";
  version = "1.0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lgfdlv0vabbhfzmrgqiq9fkwxz9v67w023rda4bszvjsxl2vaf9";
  };

  propagatedBuildInputs = [];

  doCheck = false;
  
  meta = {
    homepage = "https://github.com/CITGuru/PyInquirer/";
    description = "A collection of common interactive command line user interfaces.";
    license = lib.licenses.mit;
  };
}
