{ config, lib, ... }:

let cfg = config.vital.gitea;
    resources = (import ../../data/resources.nix);
    domain = resources.domains.gitea;
    port = resources.ports.gitea;

in {
  options.vital.gitea = {
    enable = lib.mkEnableOption "enable the gitea service.";
  };

  config = {
    services.gitea = lib.mkIf cfg.enable {
      enable = true;
      user = "git";
      # Hint browser to only send cookies via HTTPS
      # cookieSecure = true;
      domain = domain;
      httpPort = port;
      rootUrl = "http://localhost:${toString port}/";
      database = {
        user = "git";
        type = "sqlite3";
        path = "/var/lib/gitea/data/gitea.db";
      };
      extraConfig = ''
        [repository]
        DISABLE_HTTP_GIT = false
        USE_COMPAT_SSH_URI = true

        [security]
        INSTALL_LOCK = true
        COOKIE_USERNAME = gitea_username
        COOKIE_REMEMBER_NAME = gitea_userauth

        [service]
        DISABLE_REGISTRATION = true
      '';
    };
  };
}
