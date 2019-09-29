{ lib, buildPythonPackage, fetchPypi, pytest,
  rospkg, rosdistro, nose, ... }:

buildPythonPackage rec {
  pname = "rosdep";
  version = "0.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "641887cc3c349286b72b2f1357d67d91c3aa54882d7a8ca612ecc3bc684f32d5";
  };

  propagatedBuildInputs = [ rospkg rosdistro ];

  doCheck = false;
  
  meta = {
    homepage = "http://wiki.ros.org/rosdep";
    description = "rosdep is a command-line tool for installing system dependencies.";
    license = lib.licenses.bsd3;
  };
}
