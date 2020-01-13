{ stdenv, buildRosPackage, fetchFromGitHub,
  urdfdom_headers
}:

let pname = "urdf_parser_plugin";
    version = "1.12.12";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [
    urdfdom_headers
  ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "urdf-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0hrrl3y851a0lzqk0h9azk0n6ji07i7x07xdwcnr7xkbr899gjpm";
  };

  meta = {
    description = "urdf_parser_plugin";
    homepage = http://wiki.ros.org/urdf_parser_plugin;
    license = stdenv.lib.licenses.bsd3;
  };
}
