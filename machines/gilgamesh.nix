{ config, pkgs, ... }:

let nixpkgs = builtins.fetchTarball {
      name = "nixos-19.03-gilgamesh";
      url = "https://github.com/nixos/nixpkgs/archive/f52505fac8c82716872a616c501ad9eff188f97f.tar.gz";
      sha256 = "06nfl69hzxpc5nqbp6sjhx30xnrdcx9mjbf0wl9q6hcn2mpl0p49";
      # url = "https://github.com/nixos/nixpkgs/archive/cfe51be04f8b7c36fe9f71ca5835bd683ede087f.tar.gz";
      # sha256 = "06nfl69hzxpc5nqbp6sjhx30xnrdcx9mjbf0wl9q6hcn2mpl0p49";      
      # url = "https://github.com/nixos/nixpkgs/archive/1e2decf5e6f4102045c2d372befd266f1c7404e9.tar.gz";
      # sha256 = "0h7f51dfv4rsij5ni6ki1f44pn0b0g4hcmnj05hi0viscd15r7lx";
    };

in {
  # nixpkgs.pkgs = import "${nixpkgs}" {
  #   inherit (config.nixpkgs) config;
  # };

  imports = [
    ./base.nix
    ../modules/desktop
    ../modules/web/nginx.nix
    # TODO(breakds): Bring it up
    # ../modules/web/filerun.nix
  ];

  # Machine-specific networking configuration.
  networking.hostName = "gilgamesh";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "7a4bd408";

  # +----------+
  # | Desktop  |
  # +----------+

  bds.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
    nvidia = {
      # Enable this when it is no longer broken in nixos.
      enable = false;
    };
  };

  # Enable Nginx
  services.nginx.enable = true;
}
