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
    desktopManager.xfce.enable = true;

    # Automatically login as nixos.
    displayManager.slim = {
      enable = true;
      autoLogin = true;
      defaultUser = "nixos";
    };
  };

  environment.systemPackages = with pkgs; [
    vim emacs firefox git
  ];
}
