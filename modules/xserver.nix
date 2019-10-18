/*
 * This module configures options and packages for a machine who would
 * like to have GUI support (X Window System).
 */

{ config, lib, pkgs, ... }:

{
  services = {
    # X11
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";

      # When needed, have Nvidia driver installed.
      # videoDrivers = [ "nvidia" ];

      # Enable touchpad support
      libinput.enable = true;

      # Default desktop manager: gnome3.
      desktopManager.gnome3.enable = true;
      displayManager.sddm.enable = true;

      # Extra window manager: i3
      windowManager.i3 = {
        enable = true;
        configFile = ./dotfiles/i3.config;
        extraPackages = with pkgs; [ dmenu i3status i3lock termite ];
      };
    };
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
}
