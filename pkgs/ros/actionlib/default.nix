{ stdenv, buildRosPackage, fetchFromGitHub,
 message_generation, actionlib_msgs, roscpp }:

let pname = "actionlib";
    version = "1.11.13";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ message_generation actionlib_msgs roscpp ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "actionlib-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1n5v75f07k1g8ps4b821jp38l32gx2w7mizn7cw7yjg0552aw6wf";
  };

  meta = {
    description = "actionlib";
    homepage = http://wiki.ros.org/actionlib;
    license = stdenv.lib.licenses.bsd3;
  };
}
