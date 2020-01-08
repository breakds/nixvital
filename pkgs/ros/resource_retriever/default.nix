{ stdenv, buildRosPackage, fetchFromGitHub,
  rosconsole, roslib, boost162, curl }:

let pname = "resource_retriever";
    version = "1.12.5";
    subversion = "1";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ rosconsole roslib boost162 curl ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "resource_retriever-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1xb3vxy5fjwyl1kxg5r4n1x76c94fr8q368l5pm10iy8wd9ic9gy";
  };

  meta = {
    description = "resource_retriever";
    homepage = http://wiki.ros.org/resource_retriever;
    license = stdenv.lib.licenses.bsd3;
  };
}
