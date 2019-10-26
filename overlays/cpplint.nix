{ stdenv, lib, symlinkJoin, cpplintBasePackage, ... } :

# This is to add a cpplint.py executable as well, so as to please arcanist.
symlinkJoin {
  name = "cpplint.py";
  paths = [ cpplintBasePackage ];
  buildInputs = [ cpplintBasePackage ];
  postBuild = ''
    ln -s $out/bin/cpplint $out/bin/cpplint.py
    echo "Created cpplint.py soft link."
  '';
}
