# Thanks to my friend KJ Orbekk who designed the cgit/nginx module for
# this configuration:
# https://git.orbekk.com/nixos-config.git/tree/config/cgit.nix


{ config, lib, pkgs, ... }:

let webCfg = config.bds.web;
    cfg = config.bds.web.cgit;

    configFile = pkgs.writeText "cgitrc" ''
      virtual-root=/
      scan-path=${cfg.repoPath}
      cache-root=${cfg.cacheDir}
      cache-size=1000
      max-stats=year
      root-title=${cfg.title}
      root-desc=Repositories hosted at ${cfg.servedUrl}.
      source-filter=${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py
      enable-commit-graph=true
      repository-sort=age
      enable-html-serving=1
    '';

in {
  options.bds.web.cgit = with lib; {
    enable = mkEnableOption "Enable the cgit service.";
    fcgiPort = mkOption {
      type = types.port;
      description = "Port to run the fastcgi endpoint.";
      default = 5963;
    };
    gitPort = mkOption {
      type = types.port;
      description = "Port on nginx for the cgit web ui.";
      default = 5964;
    };
    cacheDir = mkOption {
      type = types.str;
      description = ''
        Path to the directory that holds the cgit cache while serving.
      '';
      default = "/var/lib/cgit/cache";
    };
    repoPath = mkOption {
      type = types.str;
      description = ''
        Path to the directory that will be scanned for git repositories.
        Discovered repos will be served via cgit.
      '';
      default = "";
      example = "/home/delegator/cgits";
    };
    syncRepo = {
      enable = mkEnableOption "Spawn a timer to sync with upstream.";
      minutes = mkOption {
        type = types.int;
        description = ''
          The frequency of sync as represented in minutes.
        '';
        default = 10;
      };
    };
    title = mkOption {
      type = types.str;
      description = "The title of the cgit web UI.";
      default = "";
    };
    servedUrl = mkOption {
      type = types.str;
      description = "The url at which cgit is served.";
      default = "";
      example = "git.breakds.org";
    };
  };

  config = lib.mkIf (webCfg.enable && cfg.enable) {
    networking.firewall.allowedTCPPorts = [ cfg.fcgiPort ];

    services.fcgiwrap = {
      enable = true;
      socketType = "tcp";
      socketAddress = "0.0.0.0:${toString cfg.fcgiPort}";
      user = "fcgi";
      group = "fcgi";
    };

    services.nginx = {
      virtualHosts = {
        "git-internal" = {
          root = "${pkgs.cgit}/cgit";
          listen = [{ addr = "*"; port = cfg.gitPort; }];
          extraConfig = "try_files $uri @cgit;";

          locations."/git/" = {
            extraConfig = ''
            rewrite ^/git/(.*) https://${cfg.servedUrl}/$1 permanent;
          '';
          };

          locations."@cgit" = {
            extraConfig = ''
            include "${pkgs.nginx}/conf/fastcgi_params";
            fastcgi_param CGIT_CONFIG "${configFile}";
            fastcgi_param SCRIPT_FILENAME "${pkgs.cgit}/cgit/cgit.cgi";
            fastcgi_param PATH_INFO       $uri;
            fastcgi_param QUERY_STRING    $args;
            fastcgi_param HTTP_HOST       $server_name;
            fastcgi_pass  127.0.0.1:${toString cfg.fcgiPort};
          '';
          };
        };
      };
    };

    systemd = {
      services.cgit-init = {
        description = "init cgit cache";
        path = [ pkgs.coreutils ];
        after = [ "networking.target" ];
        wantedBy = [ "multi-user.target" ];
        script = ''
          echo "Creating cache directory"
          mkdir -p ${cfg.cacheDir}
          chown fcgi:fcgi ${cfg.cacheDir}
        '';
      };
      timers.sync-cgit-repo = lib.mkIf cfg.syncRepo.enable {
        wantedBy = [ "timers.target" ];
        partOf = [ "sync-cgit-repo.service" ];
        # Sync every 10 minutes
        timerConfig.OnCalendar = "*:0/${toString cfg.syncRepo.minutes}";
      };
      services.sync-cgit-repo = lib.mkIf cfg.syncRepo.enable {
        serviceConfig.Type = "oneshot";
        script = ''
          for repo in $(ls -d ${cfg.repoPath}/*/); do
            cd $repo;
            GIT_SSH_COMMAND='${pkgs.openssh}/bin/ssh -i /home/breakds/.ssh/breakds_samaritan' \
                ${pkgs.git}/bin/git fetch origin master:master;
          done;
        '';
      };
    };
  };
}
