{ stdenv, fetchFromGitHub, cmake, python, gtest, ... }:

let
  rev = "1.39.19";
  gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
in
stdenv.mkDerivation rec {
  name = "emscripten-fastcomp-${rev}";

  src = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten-fastcomp";
    sha256 = "0da3mnxn29i1hg3h9padm0nk7ph2dv411hbli43in1m22n8jbbjx";
    inherit rev;
  };

  srcFL = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten-fastcomp-clang";
    sha256 = "00a8rk0n5gr2zr0lhawfdf96svywl52fi58b4351dqkg9kmjd6fw";
    inherit rev;
  };

  nativeBuildInputs = [ cmake python gtest ];
  preConfigure = ''
    cp -Lr ${srcFL} tools/clang
    chmod +w -R tools/clang
  '';
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_TARGETS_TO_BUILD='X86;JSBackend'"
    "-DLLVM_INCLUDE_EXAMPLES=OFF"
    # FIXME: Re-enable the tests.
    "-DLLVM_INCLUDE_TESTS=OFF"
    #"-DLLVM_CONFIG=${llvm}/bin/llvm-config"
    "-DLLVM_BUILD_TESTS=OFF"
    "-DCLANG_INCLUDE_TESTS=OFF"
  ] ++ (stdenv.lib.optional stdenv.isLinux
    # necessary for clang to find crtend.o
    "-DGCC_INSTALL_PREFIX=${gcc}"
  );
  enableParallelBuilding = true;

  passthru = {
    isClang = true;
    inherit gcc;
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/emscripten-core/emscripten-fastcomp";
    description = "Emscripten LLVM";
    platforms = platforms.all;
    maintainers = with maintainers; [ qknight matthewbauer ];
    license = stdenv.lib.licenses.ncsa;
  };
}
