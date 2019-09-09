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
      displayManager.gdm.enable = true;
    };
  };

  # Font
  fonts.fonts = [
    # Add Wenquanyi Microsoft Ya Hei, a nice-looking Chinese font.
    pkgs.wqy_microhei
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
