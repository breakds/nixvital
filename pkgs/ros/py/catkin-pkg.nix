{ lib, buildPythonApplication, fetchPypi } :

let pname = "catkin_pkg";
    version = "0.4.13";
    sha256 = "3aff32871b38630b2dad1b06eb96cac6b6b3f29adfef44f714fbdd3f12dba290";
    
    homepage = "https://github.com/ros-infrastructure/catkin_pkg";
    description = "Library for retrieving information about catkin packages.";
    license = lib.licenses.bsd3;

in buildPythonApplication rec {
  inherit pname version;
  src = fetchPypi { inherit pname version sha256; };
  meta = with lib; {
    inherit homepage description license;
  };
}
