{ lib, pkgs, buildPythonPackage, fetchPypi, pytest,
  ipykernel, ipywidgets, matplotlib,
  ... }:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m5sh2ha9hlgigc5xxsy7nd0gdadx797h1i66i9z616p0r43gx7d";
  };

  propagatedBuildInputs = [ ipykernel matplotlib ipywidgets ];

  checkInputs = [];

  # doCheck = false;

  meta = {
    homepage = "http://matplotlib.org/";
    description = "Matplotlib Jupyter Extension";
    license = lib.licenses.bds3;
  };
}
