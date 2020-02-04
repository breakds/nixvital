{
  ports = {
    hydra.master = 8017;
    filerun = 5962;
    cgit.fcgi = 5963;
    cgit.web = 5964;
    gitea = 5965;
    deluge = {
      daemon = 10733;
      listen = [ 10781 10789 ];
    };
    nixvital-reflection = 5888;
  };
  domains = {
    cgit = "cgit.breakds.org";
    gitea = "git.breakds.org";
    filerun = "files.breakds.org";
  };
}
