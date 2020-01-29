{
  ports = {
    hydra.master = 8017;
    filerun = 5962;
    cgit.fcgi = 5963;
    cgit.web = 5964;
    gitea = 5965;
  };
  domains = {
    gitea = "gitea.breakds.org";
  };
}
