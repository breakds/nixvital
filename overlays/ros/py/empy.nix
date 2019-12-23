{ lib, buildPythonApplication, fetchPypi } :

let pname = "empy";
    version = "3.3.4";
    sha256 = "73ac49785b601479df4ea18a7c79bc1304a8a7c34c02b9472cf1206ae88f01b3";

in buildPythonApplication rec {
  inherit pname version;
  src = fetchPypi { inherit pname version sha256; };
  meta = with lib; {
    homepage = http://www.alcyone.com/software/empy/;
    description = "EmPy is a system for embedding Python expressions and statements";
    license = licenses.lgpl3;
  };
}
