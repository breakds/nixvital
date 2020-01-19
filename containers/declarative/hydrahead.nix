# To disable the container, just remove it from configuration.nix and
# run nixos-rebuild switch. Note that this will not delete the root
# directory of the container in /var/lib/containers. Containers can be
# destroyed using the imperative method: nixos-container destroy foo.

{ config, lib, pkgs, ... }:

{

  # Declarative containers can be started and stopped using the
  # corresponding systemd service, e.g.
  # systemctl start container@hydrahead.
  
  containers.hydrahead = {
    autoStart = true;

    privateNetwork = true;
    hostAddress = "192.168.86.26"; 
    localAddress = "192.168.88.26";
    
    config = { config, pkgs, ... }: {
      imports = [
        ../container-base.nix
        ../../modules/user.nix
      ];

      boot.isContainer = true;

      environment.systemPackages = with pkgs; [
        (callPackage ../../pkgs/public-web {})
      ];

      networking.hostName = "hydrahead";
    };
  };
}
