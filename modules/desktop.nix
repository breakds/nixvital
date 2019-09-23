{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Multimedia
    audacious audacity
  ];
}
