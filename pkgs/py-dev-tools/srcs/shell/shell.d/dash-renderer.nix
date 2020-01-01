{ lib, pkgs, buildPythonPackage, fetchPypi, pytest,
  ... }:

buildPythonPackage rec {
  pname = "dash-renderer";
  version = "1.2.0";

  src = fetchTarball "https://files.pythonhosted.org/packages/eb/a1/ca9730dce98865e1902f36f0eac9e98e30203a1a0e45c23ad2b74cd309b3/dash_renderer-1.2.0.tar.gz";

  propagatedBuildInputs = [];

  checkInputs = [];

  # doCheck = false;

  meta = {
    homepage = "https://pypi.org/project/dash-renderer/";
    description = "Front-end component renderer for Dash";
    license = lib.licenses.mit;
  };
}
