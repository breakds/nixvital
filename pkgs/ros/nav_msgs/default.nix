{ stdenv, buildRosPackage, fetchFromGitHub,
 std_msgs, message_generation, message_runtime, actionlib_msgs, geometry_msgs }:

let pname = "nav_msgs";
    version = "1.12.7";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [ std_msgs message_generation message_runtime actionlib_msgs geometry_msgs ];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "common_msgs-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "1xzg8x6fn0kb799d4ianh5sxwmxr2rl3nm20xr7adw2a86v4g1jp";
  };

  meta = {
    description = "nav_msgs";
    homepage = http://wiki.ros.org/nav_msgs;
    license = stdenv.lib.licenses.bsd3;
  };
}
