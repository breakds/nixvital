{ lib, buildPythonApplication, fetchPypi,
  rospkg, rosdistro,
  nose, mock, flake8 }:


let pname = "rosdep";
    version = "0.18.0";
    sha256 = "1164qnknxq9ba78zhfmm7jxq21j09wpjk3ip6ppwhf9pnx89f5w6";
    
    homepage = http://wiki.ros.org/rosdep;
    description = "Command-line tool for installing system dependencies on a variety of platforms.";
    license = lib.licenses.bsd3;

    propagatedBuildInputs = [ rospkg rosdistro ];

in buildPythonApplication rec {
  inherit pname version propagatedBuildInputs;
  
  src = fetchPypi { inherit pname version sha256; };

  doCheck = false;

  meta = with lib; {
    inherit homepage description license;
  };
}
