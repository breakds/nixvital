{ stdenv, buildRosPackage, fetchFromGitHub }:

let pname = "rosbag_migration_rule";
    version = "1.0.0";
    subversion = "0";
    rosdistro = "kinetic";

in buildRosPackage {
  name = "${pname}-${version}";

  propagatedBuildInputs  = [];

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "rosbag_migration_rule-release";
    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";
    sha256 = "0w2db6jsz9x6xi5dfqzk4w946i5xrjqal78bbyswc645rv7nskbn";
  };

  meta = {
    description = "rosbag_migration_rule";
    homepage = http://wiki.ros.org/rosbag_migration_rule;
    license = stdenv.lib.licenses.bsd3;
  };
}
