{ config, lib, pkgs, ... }:

let installer = pkgs.callPackage ../../pkgs/nixvital-web-installer {};

    makeProg = args: pkgs.substituteAll (args // {
      dir = "bin";
      isExecutable = true;
    });

    nixos-generate-config = makeProg {
      name = "nixos-generate-config";
      src = <nixpkgs/nixos/modules/installer/tools/nixos-generate-config.pl>;
      path = lib.optionals (lib.elem "btrfs" config.boot.supportedFilesystems) [ pkgs.btrfs-progs ];
      perl = "${pkgs.perl}/bin/perl -I${pkgs.perlPackages.FileSlurp}/${pkgs.perl.libPrefix}";
      inherit (config.system.nixos-generate-config) configuration;
    };    

in {
  config = {
    systemd.services.nixvital-web-installer = {
      description = "The web UI version of nixvital installer.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        installer
        utillinux
        parted
        dosfstools
        e2fsprogs
        nixos-generate-config
      ];

      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${installer}/bin/run_nixvital_installer
        '';
        Restart = "always";
      };
    };
  };
}
