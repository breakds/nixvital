{ config, lib, pkgs, ... }:

let installer = pkgs.callPackage ../../pkgs/nixvital-web-installer {};

    cfg = config.vital.nixvital-web-installer;

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
  options.vital.nixvital-web-installer = with lib; {
    # There is no "enable" because usually this is included by livecd,
    # and when it is included, it is pretty sure they want it enabled.
    defaultNixvital = mkOption {
      type = types.str;
      description = ''
        The web app will give a default nixvital repo before the users
        decide to change it. This option sets the default url to that repo.
      '';
      default = "https://github.com/breakds/nixvital.git";
      example = "https://github.com/breakds/nixvital.git";
    };


    extraFields = let fieldOption = types.submodule {
      options = {
        key = mkOption {
          type = types.str;
          description = "The key that uniquely indentifies the field.";
        };
        name = mkOption {
          type = types.str;
          description = "The name shown on the web app for this field.";
        };
        nixVar = mkOption {
          type = types.str;
          description = "The nix variable that will be set for this field.";
        };
        description = mkOption {
          type = types.str;
          description = "The description for this field that will be shown as the placeholder.";
        };
      };
    }; in mkOption {
      type = types.listOf fieldOption;
      description = ''
        For some variation of nixvital, there are more fields to be filled
        other than username and hostname. Those fields can be configured
        here so that the user gets to set that via the web app and have
        the values filled to their generated configuration.
      '';
      default = [];
    };
  };
    
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
        ExecStart = let extraFieldYaml = if (lib.length cfg.extraFields) == 0
                                         then null
                                         else pkgs.writeTextFile {
                                           name = "nixvital-installer-extra-fields";
                                           executable = false;
                                           text = lib.generators.toYAML {} cfg.extraFields;
                                         };
                        extraFieldCmdArgs = if extraFieldYaml == null
                                            then ""
                                            else "-e ${extraFieldYaml}";
                    in ''
                      ${installer}/bin/run_nixvital_installer \
                          --default_nixvital_url ${cfg.defaultNixvital} \
                          ${extraFieldCmdArgs}
                    '';
        Restart = "always";
      };
    };
  };
}
