# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=[this-nix-file]

{config, lib, pkgs, ...}:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix>
    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  nixpkgs.config.allowUnfree = true;

  services.xserver = {
    desktopManager.mate.enable = true;
    # Enable touchpad support
    libinput.enable = true;

    displayManager.slim.enable = lib.mkForce false;
    # Automatically login as nixos.
    displayManager.sddm = {
      enable = true;
      autoLogin = {
        enable = true;
        user = "nixos";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vim emacs firefox git
  ];

  system.activationScripts.installerDesktop = let
    # Comes from documentation.nix when xserver and nixos.enable are true.
    manualDesktopFile = "/run/current-system/sw/share/applications/nixos-manual.desktop";

    homeDir = "/home/nixos/";
    desktopDir = homeDir + "Desktop/";

  in ''
    mkdir -p ${desktopDir}
    chown nixos ${homeDir} ${desktopDir}
    ln -sfT ${manualDesktopFile} ${desktopDir + "nixos-manual.desktop"}
    ln -sfT ${pkgs.gparted}/share/applications/gparted.desktop ${desktopDir + "gparted.desktop"}
  '';
}
