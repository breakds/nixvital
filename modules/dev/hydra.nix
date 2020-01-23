{ config, lib, pkgs, ... }:

let hydraToken = "hydra.breakds.org-1";
    hydraKeyDir = "/etc/nix/${hydraToken}";

in {
  # +------------------------------------------------------------+
  # | Databsae: Postgresql                                       |
  # +------------------------------------------------------------+

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_11;
    dataDir = "/var/db/postgresql-${config.services.postgresql.package.psqlSchema}";
    extraConfig = ''
      max_connections = 250
      work_mem = 128MB
      shared_buffers = 512MB
    '';
  };

  # +------------------------------------------------------------+
  # | Hydra Deployment                                           |
  # +------------------------------------------------------------+

  services.hydra = {
    enable = true;
    hydraURL = "https://hydra.breakds.org";
    notificationSender = "bds@breakds.org";
    buildMachinesFiles = [];
    port = 8080;
    useSubstitutes = true;
    extraConfig = ''
      store_uri = file:///var/lib/hydra/cache?secret-key=${hydraKeyDir}/secret
      binary_cache_secret_key_file = ${hydraKeyDir}/secret
      binary_cache_dir = /var/lib/hydra/cache
    '';
    # logo = ./hydra.png
  };

  networking.firewall.allowedTCPPorts = [ config.services.hydra.port ];

  # +------------------------------------------------------------+
  # | Hydra Initial Manual Setup                                 |
  # +------------------------------------------------------------+

  # Credit to https://github.com/peti/hydra-tutorial/blob/master/hydra-master.nix

  systemd.services.hydra-manual-setup = {
    description = "Create Admin User for Hydra";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExist = true;
    };

    # So that we get the PATH that contains the binaries we run
    environment = lib.mkForce config.systemd.services.hydra-init.environment;

    wantedBy = [ "multi-user.target" ];
    requires = [ "hydra-init.service" ];
    after = [ "hydra-init.service" ];

    # TODO(breakds): Figure out whether the admin user is useful.
    script = ''
      if [ ! -e ~hydra/.setup-is-complete ]; then
         # Create admin user, for web sign-in
         /run/current-system/sw/bin/hydra-create-user breakds \
             --full-name 'Master Break' \
             --email-address 'bds@breakds.org' \
             --password foobar \
             --role admin
         # Create signing keys
         /run/current-system/sw/bin/install -d -m 551 ${hydraKeyDir}
         /run/current-system/sw/bin/nix-store --generate-binary-cache-key \
             hydra.breakds.org-1 \
             ${hydraKeyDir}/secret ${hydraKeyDir}/public
         /run/current-system/sw/bin/chown -R hydra:hydra ${hydraKeyDir}
         /run/current-system/sw/bin/chmod 440 ${hydraKeyDir}/secret
         /run/current-system/sw/bin/chmod 444 ${hydraKeyDir}/public
         # Indicate Setup Complete
         touch ~hydra/.setup-is-complete
      fi
    '';
  };

  # +------------------------------------------------------------+
  # | Build Machines and Settings                                |
  # +------------------------------------------------------------+

  # Credit: http://qfpl.io/posts/nix/starting-simple-hydra/
  nix = {
    trustedUsers = ["hydra" "hydra-evaluator" "hydra-queue-runner"];
    distributedBuilds = true;
    nrBuildUsers = 16;
    gc = {
      automatic = true;
      dates = "0 0 1 * *"; # On the first day of every month.
    };
    autoOptimiseStore = true;

    buildMachines = [{
      hostName = "localhost";
      systems = [ "x86_64-linux" "i686-linux" ];
      maxJobs = "4";
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
    }];
  };
}
