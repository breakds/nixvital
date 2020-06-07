{ config, pkgs, ... }:

{
  imports = [
    ../base
    ../../nix-home/cassandra
    ../../modules/users
    ../../modules/desktop
    ../../modules/dev/vscode.nix
    ../../modules/IoT/apple-devices.nix
  ];

  vital.machineType = "laptop";

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
  };

  # +----------+
  # | Extras   |
  # +----------+

  environment.systemPackages = with pkgs; [
    gimp peek gnupg pass libreoffice
    nodejs-12_x
    skypeforlinux
  ];

  vital.security.enableFingerprint = true;
}
