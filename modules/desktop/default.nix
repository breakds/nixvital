{ config, lib, pkgs, ... }:

let cfg = config.bds.desktop;

    types = lib.types;

    xserverOptions = {
      options = {
        displayManager = lib.mkOption {
          type = types.enum [ "gdm" "sddm" "slim" ];
          default = "gdm";
          description = ''
            To use gdm or sddm for the display manager.
            Values can be "gdm" or "sddm".
'         '';
        };
        i3_show_battery = lib.mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to show battery on i3 status bar.
          '';
        };
        dpi = lib.mkOption {
          type = types.nullOr types.ints.positive;
          default = null;
          description = "DPI resolution to use for x server.";
        };
        useCapsAsCtrl = lib.mkEnableOption ''
          If enabled, caps lock will be used as an extral Ctrl key.
          Most useful for laptops.
        '';
      };
    };

in {
  imports = [
    ./nvidia.nix
    ./i3_status.nix
    ./remote-desktop.nix
  ];

  options.bds.desktop = {
    enable = lib.mkEnableOption "Enable Desktop";
    xserver = lib.mkOption {
      description = "Wrapper of xserver related configuration.";
      type = types.submodule xserverOptions;
    };
    nvidia = {
      enable = lib.mkEnableOption "Add Nivdia driver.";
      prime = {
        enable = lib.mkEnableOption ''
          Enable optimus prime mode. This is usually for laptop only.
        '';

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
            The bus ID of the nvidia video card, can be found by "lspci".
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Multimedia
      audacious audacity zoom-us thunderbird
    ];

    services.xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e" + (if cfg.xserver.useCapsAsCtrl then ", ctrl:nocaps" else "");

      # DPI
      dpi = cfg.xserver.dpi;

      # Enable touchpad support
      libinput.enable = true;

      # Default desktop manager: gnome3.
      desktopManager.gnome3.enable = true;
      desktopManager.gnome3.extraGSettingsOverrides = ''
        [org.gnome.desktop.peripherals.touchpad]
        click-method='default'
      '';
      displayManager.gdm.enable = cfg.xserver.displayManager == "gdm";
      displayManager.sddm.enable = cfg.xserver.displayManager == "sddm";
      displayManager.slim.enable = cfg.xserver.displayManager == "slim";

      # Extra window manager: i3
      windowManager.i3 = {
        enable = true;
        configFile = ./i3.config;
        extraPackages = with pkgs; [ dmenu i3status-rust i3lock termite i3lock-fancy ];
      };
    };

    # Font
    fonts.fonts = with pkgs; [
      # Add Wenquanyi Microsoft Ya Hei, a nice-looking Chinese font.
      wqy_microhei
      # Fira code is a good font for coding
      fira-code
      fira-code-symbols
      font-awesome-ttf
      inconsolata
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
