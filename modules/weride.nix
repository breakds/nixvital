{ config, lib, pkgs, ... }:

let cfg = config.vital.weride;

    types = lib.types;

in {

  options.vital.weride = {
    # For nas devices
    nasDevices = lib.mkOption {
      type = types.attrsOf (types.submodule {
        options = {

          source = lib.mkOption {
            type = types.str;
            default = "";
            description = ''
              The endpoint to connect to the nas device. e.g. //<ip>/<path>
            '';
          };
          
          fsType = lib.mkOption {
            type = types.enum [ "cifs" ];
            default = "cifs";
            description = "The filesystem type such as cifs (samba)";
          };

          credentials = lib.mkOption {
            type = types.str;
            default = "/home/breakds/.ussmbcredentials";
            description = "The samba credentials that contains username/password.";
          };
        };
      });

      default = {};

      description = "List of specifications for mouting NAS devices.";

      example = [{
        source = "//10.1.50.20/Public";
        fsType = "cifs";
      }];
    };
  };

  config = {
    nixpkgs.overlays = lib.mkIf (lib.any (x: x == "weride") config.vital.machineTags) (
      let weride-overlay = builtins.fetchGit {
            url = "http://monster.corp.weride.ai/weride-infra/weride-nix-overlay.git";
            rev = "080b84d98a14c6485b36795dec1b0dc60cb407c3";
          }; in [
            (import "${weride-overlay}/default.nix")
          ]);

    # Add arcanist for phabricator related stuff.
    environment.systemPackages = with pkgs; [
      arcanist axel cpplint patchedHostname openconnect
      bazel old-jetbrains.clion
      jc_artifact
    ];

    # Mount NAS
    fileSystems = lib.mapAttrs (target: deviceCfg: {
      device = deviceCfg.source;
      fsType = deviceCfg.fsType;
      options = let
        # this line prevents hanging on network split.
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        iocharset_opts = "iocharset=utf8";
        uid_opts = "uid=1000,gid=1000";
      in ["${automount_opts},credentials=${deviceCfg.credentials},${iocharset_opts},${uid_opts}"];
    }) cfg.nasDevices;
  };
}
