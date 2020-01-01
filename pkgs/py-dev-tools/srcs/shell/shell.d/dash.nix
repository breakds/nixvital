{ lib, pkgs, buildPythonPackage, fetchPypi, pytest,
  plotly, dash-html-components, dash-renderer, dash-table,
  dash-core-components,
  flask, flask-compress, future,
  pyyaml, selenium, coloredlogs, fire, percy, beautifulsoup4, ... }:

buildPythonPackage rec {
  pname = "dash";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d7wbi4b3c10q31mcd2g96kzbh2jcs0f8jgg0q9igwxp8lgad2rw";
  };

  propagatedBuildInputs = [
    plotly
    dash-html-components
    dash-core-components
    dash-renderer
    dash-table
    flask
    flask-compress
    future
  ];

  # TODO(breakds): Make this test work when possible
  # checkInputs = [ pytest pyyaml selenium coloredlogs fire percy
  #                 beautifulsoup4 ];

  doCheck = false;

  meta = {
    homepage = "https://dash.plot.ly/";
    description = "Dash is a productive Python framework for building web applications.";
    license = lib.licenses.mit;
  };
}
