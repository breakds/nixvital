{ pkgs ? (import <nixpkgs> {}) }:

with pkgs; callPackage ./default.nix {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Foundation;
    buildJdk = jdk8;
    buildJdkName = "jdk8";
    runJdk = jdk11_headless;
    stdenv = if stdenv.cc.isClang then llvmPackages_6.stdenv else stdenv;
}
