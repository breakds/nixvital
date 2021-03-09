{ config, pkgs, ... }:

{
  # In case we need ipv4 NAT for forwarding.
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];  
  virtualisation.libvirtd.enable = true;
  users = {
    extraUsers."$[config.vital.mainUser}".extraGroups = [ "libvirtd" ];
    extraGroups.libvirtd = { members = [ "${config.vital.mainUser}" ]; };
  };
}
