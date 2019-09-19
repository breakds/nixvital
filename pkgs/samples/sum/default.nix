{a, b ? 0, c ? 0, d ? 0} :
let pkgs = import <nixpkgs> {}; in
with pkgs; derivation {
  name = "bds-sum";
  builder = "${bash}/bin/bash";
  args = [ ./sum.sh ];
  baseInputs = [ coreutils ];
  system = builtins.currentSystem;
  elements = [ a b c d ];
}
