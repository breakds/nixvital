# Thanks to KJ Obrbekk.

{ config, pkgs, ... }:

let my_steam = pkgs.steam.override {
      # Use nixos libraries instead of steam-provided
      # nativeOnly = true;
      withJava = true;
      extraPkgs = p: [
        pkgs.openldap
        pkgs.xorg.xrandr
      ];
  };
in {
  environment.systemPackages = with pkgs; [
    wine
    my_steam
    my_steam.run
    obs-studio
    imagemagick
  ];
}
