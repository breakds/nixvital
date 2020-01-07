{ stdenv, buildRosPackage, fetchFromGitHub,
  cpp_common, rostime }:

let pname = "xmlrpcpp";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ cpp_common rostime ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1v7mr6pmnijp6bkaqya8z2brfk04a1rd2lyj8m5fim58k8k8g4i1";
  };

  meta = {
    description = "xmlrpcpp";
    homepage = http://wiki.ros.org/xmlrpcpp;
    license = stdenv.lib.licenses.bsd3;
  };
}
