{ stdenv, buildRosPackage, fetchFromGitHub,
 genpy, geneus, gencpp, genmsg, gennodejs, genlisp }:

let pname = "message_generation";
    version = "0.4.0";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ genpy geneus gencpp genmsg gennodejs genlisp ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "message_generation-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0vnwr3jx0dapmyqgiy7h4qxkf837cv1wacqpxm5j10c864vmcrb3";
  };

  meta = {
    description = "message_generation";
    homepage = http://wiki.ros.org/message_generation;
    license = stdenv.lib.licenses.bsd3;
  };
}
