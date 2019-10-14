{ config, lib, pkgs, ... }:

{
  services.nginx = lib.mkIf config.services.nginx.enable {
    # Note that the nginx team recommends to use the mainline version
    # which available in nixpkgs as nginxMainline.
    package = pkgs.nginxMainline;

    # recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
