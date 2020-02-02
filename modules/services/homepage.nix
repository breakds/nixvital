{ config, lib, pkgs, ... }:

{
  options.vital.homepage = {
    enable = lib.mkEnableOption "Make it serve the homepage www.breakds.org";
  };

  config = lib.mkIf (config.vital.web.enable && config.vital.homepage.enable) {
    services.nginx = {
      virtualHosts = {
        "www.breakds.org" = {
          enableACME = true;
          forceSSL = true;
          root = pkgs.www-breakds-org;
        };
      };
    };

    vital.nixvital-reflection.show = [
      { key = "vital.homepage.enable"; val = "${toString config.vital.homepage.enable}"; }
    ];
  };
}
