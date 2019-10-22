# Thanks to my friend KJ Orbekk who designed the cgit/nginx module for
# this configuration.

{ config, lib, pkgs, ... }:

let cfg = config.bds.web;

    cacheDir = "/var/lib/cgit/cache";
    gitPath = "/home/breakds/cgits";

    fcgiPort = 5963;
    gitPort = 5964;

    configFile = pkgs.writeText "cgitrc" ''
      virtual-root=/
      scan-path=${gitPath}
      cache-root=${cacheDir}
      cache-size=1000
      max-stats=year
      root-title=KJ repositories
      root-desc=Repositories hosted at git.orbekk.com.
      enable-commit-graph=true
      repository-sort=age
      enable-html-serving=1
    '';

in lib.mkIf cfg.enable {
  services.nginx = {
    virtualHosts = {
      "git-internal" = {
        root = "${pkgs.cgit}/cgit";
        listen = [{ addr = "*"; port = gitPort; }];
        extraConfig = "try_files $uri @cgit;";

        locations."/git/" = {
          extraConfig = ''
            rewrite ^/git/(.*) https://git.breakds.org/$1 permanent;
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
            fastcgi_pass  127.0.0.1:${toString fcgiPort};
          '';
        };
      };
    };
  };

  systemd.services.cgit-init = {
    description = "init cgit cache";
    path = [ pkgs.coreutils ];
    after = [ "networking.target" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      echo "Creating cache directory"
      mkdir -p ${cacheDir}/cache
      chown fcgi:fcgi ${cacheDir}/cache
    '';
  };
}
