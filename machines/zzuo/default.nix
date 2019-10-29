{ config, lib, pkgs, ... }:

let cfg = config.others.pnc;

    # Put extra packages to install here
    extraPackages = with pkgs; [
      httpie inkscape
    ];
    
in {
  imports = [
    ./pnc_t470p.nix
  ];

  options.others.pnc = {
    user = "zzuo";
    hostName = "motion";
    hostId = "";
  };

  home-manager.users."${cfg.user}" = { pkgs, ... }: {
    home.file = {
      ".inputrc".source = .inputrc;
    };
    
    home.packages = extraPackages;

    programs.jq.enable = true;
    programs.htop = {
      enable = true;
      highlightBaseName = true;
      treeView = true;
    };

    programs.git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      # Set this if you want to
      # userName = ""
      # userEmail = ""
    };
  };
}
