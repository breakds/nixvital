{ stdenv, buildRosPackage, fetchFromGitHub,
 boost162, xmlrpcpp, rostest, rosconsole, rosunit, roscpp }:

let pname = "message_filters";
    version = "1.12.14";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ boost162 xmlrpcpp rostest rosconsole rosunit roscpp ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1zzdjx162dc79w2zh5l5pmg5s6yynzsg5x64gcf8ywr6gk5b7hr5";
  };

  meta = {
    description = "message_filters";
    homepage = http://wiki.ros.org/message_filters;
    license = stdenv.lib.licenses.bsd3;
  };
}
