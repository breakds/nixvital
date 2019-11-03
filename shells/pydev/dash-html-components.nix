{ lib, pkgs, buildPythonPackage, fetchPypi, pytest,
  ... }:

buildPythonPackage rec {
  pname = "dash-html-components";
  version = "1.0.1";

  src = fetchTarball "https://files.pythonhosted.org/packages/0d/e8/e6f68c0a3c146d15bebe8d3570ebe535abdbba90b87e548bdf3363ecddbe/dash_html_components-1.0.1.tar.gz";

  propagatedBuildInputs = [];

  checkInputs = [];

  doCheck = false;

  meta = {
    homepage = "https://github.com/plotly/dash-html-components";
    description = "Vanilla HTML components for Dash.";
    license = lib.licenses.mit;
  };
}
