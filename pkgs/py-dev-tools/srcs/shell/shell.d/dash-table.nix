{ lib, pkgs, buildPythonPackage, fetchPypi, pytest,
  ... }:

buildPythonPackage rec {
  pname = "dash-table";
  version = "4.5.0";

  src = fetchTarball "https://files.pythonhosted.org/packages/73/d0/d7c8fe8bc2198940718ef9271c0b17f65adda4976f77d458b8f496be279f/dash_table-4.5.0.tar.gz";

  propagatedBuildInputs = [];

  checkInputs = [];

  doCheck = false;

  meta = {
    homepage = "https://pypi.org/project/dash-table/";
    description = "Dash table.";
    license = lib.licenses.mit;
  };
}
