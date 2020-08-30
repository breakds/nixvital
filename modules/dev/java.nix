{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    openjdk11 gradle
  ];
}
