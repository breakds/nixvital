{ config, pkgs, ... }:

{
  imports = [
    ../base.nix
    ../../nix-home/cassandra
    ../../modules/users
    ../../modules/desktop
    ../../modules/dev/vscode.nix
  ];

  vital.machineType = "desktop";

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
    xserver.dpi = 100;
    nvidia = {
      enable = true;
      withCuda = false;
    };
  };

  # +----------+
  # | Extras   |
  # +----------+

  environment.systemPackages = with pkgs; [
    gimp peek gnupg pass libreoffice
    nodejs-12_x
  ];

  # +------------+
  # | WakeOnLan  |
  # +------------+

  services.wakeonlan.interfaces = [{
    interface = "eno1";
  }];
}
