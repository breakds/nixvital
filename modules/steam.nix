# Thanks to KJ Obrbekk.

{ config, pkgs, ... }:

let my_steam = pkgs.steam.override {
      # Use nixos libraries instead of steam-provided
      nativeOnly = true;
      withJava = true;
      extraPkgs = p: [
        pkgs.openldap
        pkgs.xorg.xrandr
      ];
  };
in {
  nixpkgs.config.allowBroken = true;

  # https://github.com/NixOS/nixpkgs/issues/45492#issuecomment-418903252
  # Set limits for esync.
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  security.pam.loginLimits = [{
    domain = "*";
    type = "hard";
    item = "nofile";
    value = "1048576";
  }];
  
  environment.systemPackages = with pkgs; [
    wine
    my_steam
    my_steam.run
    obs-studio
    imagemagick
  ];
}
