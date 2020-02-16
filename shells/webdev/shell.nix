let pkgs = import <nixpkgs> {};

    buildNodejs = pkgs.callPackage (<nixpkgs> + /pkgs/development/web/nodejs/nodejs.nix) {};

    nodejs-12 = buildNodejs {
      enableNpm = true;
      version = "12.13.0";
      sha256 = "1xmy73q3qjmy68glqxmfrk6baqk655py0cic22h1h0v7rx0iaax8";
    };

    nodejs-10 = buildNodejs {
      enableNpm = true;
      version = "10.19.0";
      sha256 = "0sginvcsf7lrlzsnpahj4bj1f673wfvby8kaxgvzlrbb7sy229v2";
    };

    nodejs-8 = buildNodejs {
      enableNpm = true;
      version = "8.17.0";
      sha256 = "1zzn7s9wpz1cr4vzrr8n6l1mvg6gdvcfm6f24h1ky9rb93drc3av";
    };

    nodejs-current = nodejs-12;

in pkgs.mkShell rec {
  name = "webd";
  
  buildInputs = with pkgs; [
    nodejs-current
    (yarn.override { nodejs = nodejs-current; })
  ];
  shellHook = ''
    export PS1="\[$(tput sgr0)\]\[\033[38;5;150m\]$(echo -e '\uf3d3')\[$(tput sgr0)\]\[\033[38;5;15m\] {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} \\$ \[$(tput sgr0)\]"
  '';
}
