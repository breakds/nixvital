# Credit to KJ Orbekk
# https://git.orbekk.com/nixos-config.git/tree/config/container.nix

{ config, lib, pkgs, ... }:

{
  config = {
    boot.isContainer = true;

    # Use ssh as the main communication channel.
    services.openssh = {
      enable = lib.mkDefault true;
      passwordAuthentication = false;
    };

    services.avahi = {
      enable = true;

      # Whether to enable the mDNS NSS (Name Service Switch) plugin.
      # Enabling this allows applications to resolve names in the
      # `.local` domain.
      nssmdns = true;

      # Whether to register mDNS address records for all local IP
      # addresses.
      publish.enable = true;
      publish.addresses = true;
    };

    security.sudo.wheelNeedsPassword = false;

    users = {
      defaultUserShell = lib.mkForce pkgs.bash;
    };

    system.activationScripts.installInitScript = ''
      ln -fs $systemConfig/init /init
      mkdir -p /sbin/init || true
      ln -fs $systemConfig/init /sbin/init
    '';

    boot.specialFileSystems."/dev/pts" = {
      options = lib.mkAfter [ "ptmxmode=666" ];
    };

    environment.etc = {
      "inputrc".text = lib.mkDefault (
        builtins.readFile <nixpkgs/nixos/modules/programs/bash/inputrc> + ''
          ## arrow up
          "\e[A":history-search-backward
          ## arrow down
          "\e[B":history-search-forward
        '');
    };
  };
}
