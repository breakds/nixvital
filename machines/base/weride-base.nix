{ config, lib, pkgs, ... }:

let cfg = config.vital;

    home-manager = builtins.fetchGit {
      url = "https://github.com/rycee/home-manager";
      ref = "release-19.09";
    };

in {
  imports = [
    ../../modules/mounts.nix
  ];

  options.vital.weride = with lib; {
    account = mkOption {
      description = "The weride (email) account to use";
      default = "not-an-user";
      type = types.str;
    };
    gitUserName = mkOption {
      description = "User name for the local git config";
      type = types.str;
    };
  };

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
      arcanist axel cpplint patchedHostname openconnect jq
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
        credentials = ../../data/nas/smbcredentials;
      };
      nasDevices."/media/us_nas_80t" = {
        source = "//10.1.50.20/80t";
        credentials = ../../data/nas/smbcredentials;        
      };
      nasDevices."/media/gz_nas_50t" = {
        source = "//10.18.50.20/Public";
        credentials = ../../data/nas/gzsmbcredentials;
      };
      nasDevices."/media/gz_nas_80t" = {
        source = "//10.18.50.20/80t";
        credentials = ../../data/nas/gzsmbcredentials;        
      };
    };

    # Setup Git with Home Manager
    home-manager.users."${cfg.mainUser}" = { pkgs, ... }: {
      programs.git = {
        package = pkgs.gitAndTools.gitFull;
        enable = true;
        userName = cfg.gitUser;
        userEmail = "${cfg.weride.account}@weride.ai";
      };
    };
  };
}
