# To disable the container, just remove it from configuration.nix and
# run nixos-rebuild switch. Note that this will not delete the root
# directory of the container in /var/lib/containers. Containers can be
# destroyed using the imperative method: nixos-container destroy foo.

{ config, lib, pkgs, ... }:

let hydraToken = "hydra.breakds.org-1";
    hydraKeyDir = "/etc/nix/${hydraToken}";

in {

  # Declarative containers can be started and stopped using the
  # corresponding systemd service, e.g.
  # systemctl start container@hydrahead.

  containers.hydrahead = {
    autoStart = true;

    # Share the host's network.
    privateNetwork = false;

    config = { config, pkgs, ... }: {
      imports = [
        ../container-base.nix
        ../../modules/users
        ../../modules/dev/hydra.nix
      ];

      # +------------------------------------------------------------+
      # | Basic Setups                                               |
      # +------------------------------------------------------------+

      networking.hostName = "hydrahead";

      # NAT rules if privateNetwork is true. The container needs to
      # talk to the outside via the host network devices.
      #
      # TODO(breakds): https://discourse.nixos.org/t/dns-in-declarative-container/1529
      #
      # networking.nat.enable = true;
      # networking.nat.internalInterfaces = ["ve-hydrahead"];
      # networking.nat.externalInterface = "eno1";

      # Set your time zone.
      time.timeZone = "America/Los_Angeles";

      fonts.fonts = with pkgs; [
        font-awesome-ttf
      ];

      environment.etc = {
        "bashrc.local".text = ''
          if [ -z "$PS1" ]; then
            return
          fi
          export PS1="\[\033[38;5;81m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@$(echo -e '\uf3b0') $(echo -e '\uf23b') $(echo -e '\uf394')$(echo -e '\uf25d')$(echo -e '\uf1fa') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} \\$ \[$(tput sgr0)\]"
        '';
      };
    };
  };
}
