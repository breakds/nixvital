{ config, lib, pkgs, ... }:

let cfg = config.vital.desktop;

    types = lib.types;

    xserverOptions = {
      options = {
        displayManager = lib.mkOption {
          type = types.enum [ "gdm" "sddm" ];
          default = "gdm";
          description = ''
            To use gdm or sddm for the display manager.
            Values can be "gdm" or "sddm".
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
    ./wacom.nix
    ./remote-desktop.nix
  ];

  options.vital.desktop = {
    enable = lib.mkEnableOption "Enable Desktop";
    xserver = lib.mkOption {
      description = "Wrapper of xserver related configuration.";
      type = types.submodule xserverOptions;
    };
    nvidia = {
      enable = lib.mkEnableOption "Add Nivdia driver.";

      withCuda = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          When set to true, if nvidia is enabled, cuda will be installed too.
        '';
      };

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

    # Disable the gnome shell as it is not currently used, and will appear
    # in the dmenu so that hinder how chrome is being launched.
    services.gnome3.chrome-gnome-shell.enable = false;

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

      # Special Session managed by Home Manager.
      # This is how I get display manager recognize my customized i3.
      desktopManager.session = [
        {
          name = "home-manager";
          start = ''
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
            waitPID=$!
          '';
        }
      ];
      
      displayManager.gdm.enable = cfg.xserver.displayManager == "gdm";
      # When using gdm, do not automatically suspend since we want to
      # keep the server running.
      displayManager.gdm.autoSuspend = false;
      displayManager.sddm.enable = cfg.xserver.displayManager == "sddm";
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

    console = {
      packages = [ pkgs.wqy_microhei pkgs.terminus_font  ];
      font = "ter-132n";
    };
    
    i18n = {
      # Input Method
      inputMethod = {
        enabled = "fcitx";
        fcitx.engines = with pkgs.fcitx-engines; [cloudpinyin];
      };
    };

    hardware.opengl.setLdLibraryPath = true;
  };
}
