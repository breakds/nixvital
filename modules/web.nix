{ config, lib, pkgs, ... }:

{
  services.nextcloud = {
    enable = true;
    hostName = "nas.gilgamesh";
    nginx.enable = true;
    home = "/home/breakds/nas";

    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/tmp"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbname = "nextcloud";
      adminpass = "thisisroot";
      adminuser = "root";
    };
  };

  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "psql-init" ''
      CREATE ROLE nextcloud WITH LOGIN;
      CREATE DATABASE nextcloud WITH OWNER nextcloud;
    '';
  };

  # ensure that postgres is running *before* running the setup
  systemd.services."nextcloud-setup" = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
