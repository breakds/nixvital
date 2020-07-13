{ stdenv, cmake, python3, git, fetchFromGitHub, substituteAll }:

let
  defaultVersion = "94";

in

stdenv.mkDerivation rec {
  version = defaultVersion;
  rev = "version_${version}";
  pname = "binaryen";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    sha256 = "1wk20fhyppb2ljni7ifqnsx9kl1kcl6c0svc0qljf0bs6rvr9qdm";
    inherit rev;
  };

  # patches = stdenv.lib.optional (emscriptenRev != null) (substituteAll {
  #   src = ./0001-Get-rid-of-git-dependency.patch;
  #   emscriptenv = "1.39.1";
  # });

  nativeBuildInputs = [ cmake python3 git ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/WebAssembly/binaryen";
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ asppsa ];
    license = licenses.asl20;
  };
}

