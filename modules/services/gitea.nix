{ config, lib, ... }:

let cfg = config.vital.gitea;
    resources = (import ../../data/resources.nix);
    defaultDomain = resources.domains.gitea;
    defaultPort = resources.ports.gitea;

in {
  options.vital.gitea = {
    enable = lib.mkEnableOption "enable the gitea service.";
    domain = lib.mkOption {
      type = lib.types.str;
      description = "The domain name on which gitea is served.";
      default = defaultDomain;
      example = "git.breakds.org";
    };
    port = lib.mkOption {
      type = lib.types.port;
      description = "The port on which gitea is served.";
      default = defaultPort;
      example = 3000;
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitea = {
      enable = true;
      appName = lib.mkDefault "Gitea: Break and Shan";
      user = "git";
      
      # Hint browser to only send cookies via HTTPS
      # cookieSecure = true;
      domain = cfg.domain;
      httpPort = cfg.port;
      # NOTE(breakds): This is only for showing some information on
      # the website, e.g. instructions on how to access the repository
      # when it is first created.
      rootUrl = "https://${cfg.domain}";

      database = {
        user = "git";
        type = "sqlite3";
        path = "/var/lib/gitea/data/gitea.db";
      };
      repositoryRoot = "/home/${config.services.gitea.user}/repos";

      # TODO(breakds): Enable the dump (backup), preferrably weekly.

      extraConfig = ''
        [repository]
        DISABLE_HTTP_GIT = false
        USE_COMPAT_SSH_URI = true

        [security]
        INSTALL_LOCK = true
        COOKIE_USERNAME = gitea_username
        COOKIE_REMEMBER_NAME = gitea_userauth
        
        [server]
        LANDING_PAGE = explore
      '';
    };

    services.nginx.virtualHosts = lib.mkIf config.vital.web.enable {
      "${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
    };
    
    networking.firewall.allowedTCPPorts = [ config.services.gitea.httpPort ];

    vital.nixvital-reflection.show = {
      { key = "vital.gitea.port"; val = "${toString config.vital.gitea.port}"; }
    };
  };
}
