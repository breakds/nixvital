{ stdenv, buildRosPackage, fetchFromGitHub,
 pkg-config, message_generation, message_runtime }:

let pname = "rosbuild";
    version = "1.14.6";
    subversion = "1";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ pkg-config message_generation message_runtime ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "08nffz4x7ax7594kbb23b88f478viq6zhz3ajjx8zgvrxfklx902";
  };

  meta = {
    description = "rosbuild";
    homepage = http://wiki.ros.org/rosbuild;
    license = stdenv.lib.licenses.bsd3;
  };
}
