{ lib, buildPythonPackage, fetchPypi,
  pyyaml, catkin-pkg, rospkg }:



let pname = "rosdistro";
    version = "0.8.0";
    sha256 = "1f85wqjbmi51w94wk176cqk3x2bgag2221acfdj4dsdxbzg0dkb1";
    
    homepage = http://wiki.ros.org/rosdistro;
    description = "A tool to work with rosdistro files";
    license = lib.licenses.mit;

    propagatedBuildInputs = [ pyyaml catkin-pkg rospkg ];

in buildPythonPackage rec {
  inherit pname version propagatedBuildInputs;
  
  src = fetchPypi { inherit pname version sha256; };

  meta = with lib; {
    inherit homepage description license;
  };
}
