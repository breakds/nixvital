{ lib, pkgs, buildPythonPackage, fetchPypi, pytest,
  ... }:

let optional-django = buildPythonPackage rec {
      pname = "optional-django";
      version = "0.1.0";

      src = fetchPypi {
        inherit pname version;
        sha256 = "1i96jf9z8f2qlyxm4ch0lv72bxqaksiq6imgw61hb8xxfkxvkmkp";
      };

      propagatedBuildInputs = [];

      checkInputs = [];

      meta = {
        homepage = "https://github.com/markfinger/optional-django";
        description = "Utils for providing optional support for django";
        license = lib.licenses.mit;
      };
    };
    
in buildPythonPackage rec {
  pname = "nodejs";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cr9nn09pd85j809i0ksi6gz54wdzg003pf6pd8v348sqpn5yn2c";
  };

  propagatedBuildInputs = [ optional-django ];

  checkInputs = [];

  meta = {
    homepage = "https://github.com/markfinger/python-nodejs";
    description = "Python bindings and utils for Node.js and io.js";
    license = lib.licenses.mit;
  };
}
