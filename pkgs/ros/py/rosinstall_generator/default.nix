{ lib, buildPythonApplication, fetchPypi,
  pyyaml, rosdistro, pytest }:



let pname = "rosinstall_generator";
    version = "0.1.18";
    sha256 = "18n1yyadr88hm0wlqzpr4gbyjm58kbl2i4d61vc8gij6a3fxxknz";
    
    homepage = http://wiki.ros.org/rosinstall_generator;
    description = "A tool for generating rosinstall files";
    license = lib.licenses.mit;

    propagatedBuildInputs = [ pyyaml rosdistro ];

in buildPythonApplication rec {
  inherit pname version propagatedBuildInputs;
  
  src = fetchPypi { inherit pname version sha256; };

  checkInputs = [ pytest ];

  meta = with lib; {
    inherit homepage description license;
  };
}
