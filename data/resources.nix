{
  ports = {
    hydra.master = 8017;
    filerun = 5962;
    cgit.fcgi = 5963;
    cgit.web = 5964;
    gitea = 5965;
    nix-serve = 5966;
    deluge = {
      daemon = 10733;
      listen = [ 10781 10789 ];
    };
    nixvital-reflection = 5888;
    terraria = 5970;
    jupyter-lab = 5555;
    docker-registry = 5050;
  };
  domains = {
    cgit = "cgit.breakds.org";
    gitea = "git.breakds.org";
    filerun = "files.breakds.org";
    nix-serve = "cache.breakds.org";
    docker-registry = "docker.breakds.org";
  };
}
