# This is a special pacakge.
# Note that unlike other package, console_bridge is pure CMake.
# Catkin is not needed.

{ stdenv, fetchFromGitHub, cmake }:

let pname = "console_bridge";
    version = "0.4.4";

# https://github.com/ros/console_bridge/archive/0.4.4.tar.gz    

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ros";
    repo = pname;
    rev = version;
    sha256 = "0kh0jh167q0v8705zf3gjk33rk8qy3xq42m9xmkjfirrc022b27a";
  };

  buildInputs = [ cmake ];

  meta = {
    description = ''
      A ROS-independent package for logging that seamlessly pipes into 
      rosconsole/rosout for ROS-dependent packages.
    '';
    homepage = http://wiki.ros.org/console_bridge;
    license = stdenv.lib.licenses.bsd3;
  };
}
