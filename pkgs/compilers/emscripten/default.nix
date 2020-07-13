{ stdenv, fetchFromGitHub, python, nodejs, closurecompiler
, llvmPackages_10, clang, symlinkJoin
, jre, binaryen, cmake
}:

let
  rev = "1.39.19";
  appdir = "share/emscripten";

  upstream-llvm = symlinkJoin {
    name = "emscripten-upstream-llvm-with-clang";
    # Sadly, actually we need llvm 11
    paths = [ llvmPackages_10.llvm llvmPackages_10.clang ];
    allowSubstitutes = true;
  };
  
in

stdenv.mkDerivation {
  name = "emscripten-${rev}";

  src = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten";
    sha256 = "0m5k857vyajgh2gv8xhbdwq7sipbikwx1abmbz1i9mwqyi1r1y7n";
    inherit rev;
  };

  buildInputs = [ nodejs cmake python ];

  buildCommand = ''
    mkdir -p $out/${appdir}
    cp -r $src/* $out/${appdir}
    chmod -R +w $out/${appdir}
    grep -rl '^#!/usr.*python' $out/${appdir} | xargs sed -i -s 's@^#!/usr.*python.*@#!${python}/bin/python@'
    # Force using the generated config by hijacking embedded_config, which is of very high priority.
    sed -i -e "s,embedded_config = path_from_root('.emscripten'),embedded_config = '$out/${appdir}/config'," $out/${appdir}/tools/shared.py
    sed -i -e 's,^.*did not see a source tree above the LLVM.*$,      return True,' $out/${appdir}/tools/shared.py
    sed -i -e 's,def check_sanity(force=False):,def check_sanity(force=False):\n  return,' $out/${appdir}/tools/shared.py
    # fixes cmake support
    sed -i -e "s/print \('emcc (Emscript.*\)/sys.stderr.write(\1); sys.stderr.flush()/g" $out/${appdir}/emcc.py
    mkdir $out/bin
    ln -s $out/${appdir}/{em++,em++.py,em-config,em-config.py,emar,emar.py,embuilder.py,emcc,emcc.py,emcmake,emcmake.py,emconfigure,emconfigure.py,emlink.py,emmake,emmake.py,emranlib,emrun,emrun.py,emscons} $out/bin

    echo "EMSCRIPTEN_ROOT = '$out/${appdir}'" > $out/${appdir}/config
    echo "LLVM_ROOT = '${upstream-llvm}/bin'" >> $out/${appdir}/config
    echo "PYTHON = '${python}/bin/python'" >> $out/${appdir}/config
    echo "NODE_JS = '${nodejs}/bin/node'" >> $out/${appdir}/config
    echo "JS_ENGINES = [NODE_JS]" >> $out/${appdir}/config
    echo "COMPILER_ENGINE = NODE_JS" >> $out/${appdir}/config
    echo "CLOSURE_COMPILER = '${closurecompiler}/share/java/closure-compiler-v${closurecompiler.version}.jar'" >> $out/${appdir}/config
    echo "JAVA = '${jre}/bin/java'" >> $out/${appdir}/config
    # to make the test(s) below work
    echo "SPIDERMONKEY_ENGINE = []" >> $out/${appdir}/config
    echo "BINARYEN_ROOT = '${binaryen}'" >> $out/share/emscripten/config
    echo "--------------- running test -----------------"

    # quick hack to get the test working
    HOME=$TMPDIR
    cp $out/${appdir}/config $HOME/.emscripten
    export PATH=$PATH:$out/bin

    #export EMCC_DEBUG=2  
    # ${python}/bin/python $src/tests/runner.py test_hello_world
    echo "--------------- /running test -----------------"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/emscripten-core/emscripten";
    description = "An LLVM-to-JavaScript Compiler";
    platforms = platforms.all;
    maintainers = with maintainers; [ qknight matthewbauer ];
    license = licenses.ncsa;
  };
}
