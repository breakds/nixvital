{ config, lib, pkgs, ... }:

let cfg = config.bds.desktop;

in {
  options.bds.desktop = {
    enable = lib.mkEnableOption "Enable Desktop";
    xserver = {
      displayManager = lib.mkOption {
        type = lib.types.enum [ "gdm" "sddm" ];
        default = "gdm";
        description =  ''
          To use gdm or sddm for the display manager.
          Values can be "gdm" or "sddm".
'       '';
      };
    };
    nvidia = {
      enable = lib.mkEnableOption "Add Nivdia driver.";
      prime = {
        enable = lib.mkEnableOption "Enable optimus prime mode. This is usually for laptop only.";
        # TODO(breakds): Make those two "REQUIRED" when prime is enabled.
        intelBusId = lib.mkOption {
          type = lib.types.str;
          default = "PCI:0:2:0";
          description = ''
            The bus ID of the intel video card, can be found by "lspci".
          '';
        };
        nvidiaBusId = lib.mkOption {
          type = lib.types.str;
          default = "PCI:2:0:0";
          description = ''
            The bus ID of the intel video card, can be found by "lspci".
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Multimedia
      audacious audacity zoom-us
    ];

    services.xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";

      # When needed, have Nvidia driver installed.
      videoDrivers = lib.mkIf cfg.nvidia.enable [ "nvidia" ];
      # Disable Wayland if nvidia is on.
      displayManager.gdm.wayland = !cfg.nvidia.enable;

      # Enable touchpad support
      libinput.enable = true;

      # Default desktop manager: gnome3.
      desktopManager.gnome3.enable = true;
      # displayManager.sddm.enable = true;
      # displayManager.sddm.theme = "chili";
      displayManager.gdm.enable = cfg.xserver.displayManager == "gdm";
      displayManager.sddm.enable = cfg.xserver.displayManager == "sddm";

      # Extra window manager: i3
      windowManager.i3 = {
        enable = true;
        configFile = ./dotfiles/i3.config;
        extraPackages = with pkgs; [ dmenu i3status i3lock termite ];
      };
    };

    hardware = lib.mkIf (cfg.nvidia.enable && cfg.nvidia.prime.enable) {
      # Nvidia PRIME The card Nvidia 940MX is non-MXM card. Needs special treatment.
      # muxless/non-MXM Optimus cards have no display outputs and show as 3D
      # Controller in lspci output, seen in most modern consumer laptops
      nvidia.optimus_prime.enable = true;
      nvidia.modesetting.enable = true;
      opengl.driSupport32Bit = true;

      # TODO(breakds): make those two options

      # Bus ID of the NVIDIA GPU. You can find it using lspci
      nvidia.optimus_prime.nvidiaBusId = cfg.nvidia.prime.nvidiaBusId;

      # Bus ID of the Intel GPU. You can find it using lspci
      nvidia.optimus_prime.intelBusId = cfg.nvidia.prime.intelBusId;
    };

    # Font
    fonts.fonts = with pkgs; [
      # Add Wenquanyi Microsoft Ya Hei, a nice-looking Chinese font.
      wqy_microhei
      # Fira code is a good font for coding
      fira-code
      fira-code-symbols
    ];

    # International Support
    i18n = {
      consoleFont = "ter-132n";
      consolePackages = [ pkgs.wqy_microhei pkgs.terminus_font ];

      # Input Method
      inputMethod = {
        enabled = "fcitx";
        fcitx.engines = with pkgs.fcitx-engines; [cloudpinyin];
      };
    };
  };
}
