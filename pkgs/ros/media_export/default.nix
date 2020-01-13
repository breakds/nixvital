{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "media_export";
    version = "0.2.0";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "media_export-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1yk6156n4mjvx8caykpzandj43wgwxma55xx91x8l94byk6w9jqx";
  };

  meta = {
    description = "media_export";
    homepage = http://wiki.ros.org/media_export;
    license = stdenv.lib.licenses.bsd3;
  };
}
