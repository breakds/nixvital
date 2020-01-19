# To disable the container, just remove it from configuration.nix and
# run nixos-rebuild switch. Note that this will not delete the root
# directory of the container in /var/lib/containers. Containers can be
# destroyed using the imperative method: nixos-container destroy foo.

{ config, lib, pkgs, ... }:

{

  # Declarative containers can be started and stopped using the
  # corresponding systemd service, e.g.
  # systemctl start container@hydra-master.
  
  containers.hydra-master = {
    config = {
      imports = [
        ../container-base.nix
        ../../modules/user.nix
      ];

      networking.hostName = "hydra-master";
    };
  };
}
