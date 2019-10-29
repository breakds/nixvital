{ config, lib, pkgs, ... }:

let cfg = config.others.pnc;
  
    home-manager = builtins.fetchGit {
      url = "https://github.com/rycee/home-manager";
      ref = "release-19.09";
    };

in {
  imports = [
    "${home-manager}/nixos"
  ];

  home-manager.users."${cfg.user}" = { pkgs, ... }: {
    home.file = {
      ".inputrc".source = ./pnc_dotfiles/inputrc;
    };
    
    home.packages = with pkgs; [
      neofetch
      httpie
    ];

    programs.jq.enable = true;
    programs.htop = {
      enable = true;
      highlightBaseName = true;
      treeView = true;
    };

    programs.git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
    };
  };
}
