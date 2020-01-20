let
  pkgs = import <nixpkgs> {};

  jobs = rec {
    tarball = pkgs.releaseTools.sourceTarball {
      name = "hello-tarball";
      src = <hello>;
      buildInputs = (with pkgs; [ gettext texLive texinfo ]);
    };

    build =  { system ? builtins.currentSystem }:
      let pkgs = import <nixpkgs> { inherit system; }; in
      pkgs.releaseTools.nixBuild {
        name = "hello";
        src = jobs.tarball;
        configureFlags = [ "--disable-silent-rules" ];
      };
  };
in jobs
