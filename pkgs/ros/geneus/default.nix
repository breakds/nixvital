{ stdenv, buildRosPackage, fetchFromGitHub,
  genmsg }:

let pname = "geneus";
    version = "2.2.6";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ genmsg ];

  src = fetchFromGitHub {
    owner = "tork-a";
    repo = "geneus-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0gdw4ph0ixirkg0c1kp8lqdf9kpjfc59iakpf5i1cvy1fvff0kcd";
  };

  meta = {
    description = "geneus";
    homepage = http://wiki.ros.org/geneus;
    license = stdenv.lib.licenses.bsd3;
  };
}
