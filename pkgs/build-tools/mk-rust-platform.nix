# Credit to the post at https://discourse.nixos.org/t/how-can-i-use-rustc-unstable-with-rustplatform-buildrustpackage-solved/3526/6

{ callPackage, fetchFromGitHub, makeRustPlatform }:

{ date, channel }:

let mozillaOverlay = fetchFromGitHub {
      owner = "mozilla";
      repo = "nixpkgs-mozilla";
      rev = "5300241b41243cb8962fad284f0004afad187dad";
      sha256 = "1h3g3817anicwa9705npssvkwhi876zijyyvv4c86qiklrkn5j9w";
    };
    mozilla = callPackage "${mozillaOverlay.out}/package-set.nix" {};
    rustSpecific = (mozilla.rustChannelOf { inherit date channel; }).rust;

in makeRustPlatform {
  cargo = rustSpecific;
  rustc = rustSpecific;
}
