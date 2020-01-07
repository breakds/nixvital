{ stdenv, buildRosPackage, fetchFromGitHub,
 message_generation, std_msgs, message_runtime }:

let pname = "actionlib_msgs";
    version = "1.12.7";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ message_generation std_msgs message_runtime ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "common_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0fh08fy08bz3cbp670r00jkdjw54rhdvjjwva8gkqi1syaxgzjjj";
  };

  meta = {
    description = "actionlib_msgs";
    homepage = http://wiki.ros.org/actionlib_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
