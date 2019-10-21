# Thanks to my friend KJ Orbekk who designed the cgit/nginx module for
# this configuration.

{ config, lib, pkgs, ... }:

let cacheDir = "/var/lib/cgit/cache";

in {
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
