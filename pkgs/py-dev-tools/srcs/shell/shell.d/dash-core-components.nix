{ lib, pkgs, buildPythonPackage, fetchPypi, pytest,
  ... }:

buildPythonPackage rec {
  pname = "dash-core-components";
  version = "1.4.0";

  src = fetchTarball "https://files.pythonhosted.org/packages/ad/79/d9704b9da2e26fa249cc05ceaa5f806006ce8b528982fb66d1d74ccf53f3/dash_core_components-1.4.0.tar.gz";

  propagatedBuildInputs = [];

  checkInputs = [];

  doCheck = false;

  meta = {
    homepage = "https://github.com/plotly/dash-core-components";
    description = "CORE components suite for Dash.";
    license = lib.licenses.mit;
  };
}
