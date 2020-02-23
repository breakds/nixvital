{ stdenv, ... };

stdenv.mkDerivation rec {
  name = "etherpad-lite-${version}";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "ehter";
    repo = "etherpad-lite";
    rev = "1.8.0";
    sha256 = "03ykxqfh7p7vpgcivyx2s4z87mybpnqk4ni2rrn7irzw79hga9a1";
  };
}
