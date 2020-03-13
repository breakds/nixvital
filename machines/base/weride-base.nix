{ config, lib, pkgs, ... }:

let cfg = config.vital;

in {
  imports = [
    ../../modules/mounts.nix
  ];
  
  config = lib.mkIf (lib.any (x: x == "weride") config.vital.machineTags) {
    # NOTE(breakds): For development, one solution is to temporarily
    # import the overlay from a local development repo of the overlay.
    nixpkgs.overlays = lib.mkIf (lib.any (x: x == "weride") config.vital.machineTags) (
      let weride-overlay = builtins.fetchGit {
            url = "http://monster.corp.weride.ai/weride-infra/weride-nix-overlay.git";
            rev = "819ec1b226004de247d4d9f0ba7922e9ca193587";
          }; in [
            (import "${weride-overlay}/default.nix")
          ]);

    environment.systemPackages = with pkgs; [
      arcanist axel cpplint patchedHostname openconnect
      htop neofetch vim terminator
      old-jetbrains.clion
      autoconf
      automake

      # First-party Tools
      jc_artifact
      jc_tune
    ];

    vital.mounts = {
      nasDevices."/media/nas" = {
        source = "//10.1.50.20/Public";
        credentials = "/home/${cfg.mainUser}/.ussmbcredentials";
      };
      nasDevices."/media/us_nas_80t" = {
        source = "//10.1.50.20/80t";
        credentials = "/home/${cfg.mainUser}/.ussmbcredentials";
      };
      nasDevices."/media/gz_nas_50t" = {
        source = "//10.18.50.20/Public";
        credentials = "/home/${cfg.mainUser}/.gzsmbcredentials";
      };
      nasDevices."/media/gz_nas_80t" = {
        source = "//10.18.50.20/80t";
        credentials = "/home/${cfg.mainUser}/.gzsmbcredentials";
      };
      nasDevices."/media//hdfs" = {
        source = "//10.18.51.1/hdfs";
        credentials = "/home/${cfg.mainUser}/.gzhdfscredentials";
      };
    };
  };
}
