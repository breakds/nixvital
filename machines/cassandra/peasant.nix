{ config, pkgs, ... }:

{
  imports = [
    ../base
    ../../nix-home/cassandra
    ../../modules/users
    ../../modules/desktop
    ../../modules/dev/vscode.nix
    ../../modules/dev/python-environment.nix
    ../../modules/IoT/apple-devices.nix
    ../../modules/steam.nix
  ];

  vital.machineType = "laptop";

  vital.dev.python = {
    batteries.machineLearning = false;
  };

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    xserver.displayManager = "lightdm";
    nvidia = {
      enable = true;
      prime = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # +----------+
  # | Extras   |
  # +----------+

  users.users."${config.vital.mainUser}".shell = pkgs.bash;

  environment.systemPackages = with pkgs; [
    gimp peek gnupg pass libreoffice
    nodejs-12_x
    skypeforlinux
  ];
}
