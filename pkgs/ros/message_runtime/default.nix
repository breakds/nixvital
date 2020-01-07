{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "message_runtime";
    version = "0.4.12";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "message_runtime-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0mh60p1arv7gj0w0wgg3c4by76dg02nd5hkd4bh5g6pgchigr0qy";
  };

  meta = {
    description = "message_runtime";
    homepage = http://wiki.ros.org/message_runtime;
    license = stdenv.lib.licenses.bsd3;
  };
}
