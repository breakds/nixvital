{ stdenv, buildRosPackage, fetchFromGitHub,
  rosPythonPackages,
  
}:

let pname = "rosgraph";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [
    rosPythonPackages.rospkg
    rosPythonPackages.netifaces
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1xpmlbdwg0qc5p285xlb0h0h1ajyd5h4ddq91wijpczz5y8dwdm4";
  };

  meta = {
    description = "rosgraph";
    homepage = http://wiki.ros.org/rosgraph;
    license = stdenv.lib.licenses.bsd3;
  };
}
