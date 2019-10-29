{ config, lib, pkgs, ... }:

let cfg = config.others.pnc;

in {
  imports = [
    ../base.nix
    ./pnc_home.nix
    ../../modules/desktop
    ../../modules/weride.nix
  ];

  options.others.pnc = with lib; {
    user = mkOption {
      description = "The user name";
      type = types.str;
    };
    hostName = mkOption {
      description = "networking.hostName";
      type = types.str;
    };
    hostId = mkOption {
      description = "networking.hostId";
      type = types.str;
    };
  };

  config = {
    # Machine-specific networking configuration.
    networking.hostName = cfg.hostName;
    networking.hostId = cfg.hostId;

    environment.systemPackages = with pkgs; [
      arcanist axel cpplint patchedHostname
      htop neofetch vim terminator
    ];

    programs.bash.shellInit = ''
      export PS1="\[\033[38;5;81m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;214m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} \\$ \[$(tput sgr0)\]"
      export EDITOR=vim
      neofetch
    '';

    # +----------+
    # | Desktop  |
    # +----------+

    bds.desktop = {
      enable = true;
      xserver.displayManager = "sddm";
      xserver.i3_show_battery = true;
      nvidia = {
        enable = true;
        prime = {
          enable = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:2:0:0";
        };
      };
    };

    services.xserver.dpi = 142;

    # +----------+
    # | Weride   |
    # +----------+

    bds.weride = {
      nasDevices."/media/nas" = {
        source = "//10.1.50.20/Public";
        credentials = "/home/${cfg.user}/.ussmbcredentials";
      };
      nasDevices."/media/us_nas_80t" = {
        source = "//10.1.50.20/80t";
        credentials = "/home/${cfg.user}/.ussmbcredentials";
      };
      nasDevices."/media/gz_nas_50t" = {
        source = "//10.18.50.20/Public";
        credentials = "/home/${cfg.user}/.gzsmbcredentials";
      };
      nasDevices."/media/gz_nas_80t" = {
        source = "//10.18.50.20/80t";
        credentials = "/home/${cfg.user}/.gzsmbcredentials";
      };
    };

    # +----------+
    # | Users    |
    # +----------+

    users = {
      extraUsers = {
        "${cfg.user}" = {
          isNormalUser = true;
	        initialPassword = cfg.user;
	        home = "/home/${cfg.user}";
          uid = 1000;
	        description = "${cfg.user}";
          extraGroups = [
	          cfg.user
	          "wheel"  # Enable `sudo`
	          "networkmanager"
	          "dialout"  # Access /dev/ttyUSB* devices
	          "uucp"  # Access /ev/ttyS... RS-232 serial ports and devices.
	          "audio"
	          "plugdev"  # Allow members to mount/umount removable devices via pmount.
	          "docker"
	        ];
          useDefaultShell = true;
        };
      };

      extraGroups = {
        "${cfg.user}" = { gid = 1000; members = [ cfg.user ]; };
      };
    };

    # Enable nvidia-docker
    virtualisation.docker.enableNvidia = true;
  };
}
