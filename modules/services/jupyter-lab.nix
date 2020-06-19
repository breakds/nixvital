{ config, pkgs, lib, ... }:

let cfg = config.vital.jupyter-lab;

in {
  options.vital.jupyter-lab = with lib; {
    enable = mkEnableOption "Enable the Jupyter Lab service.";

    user = mkOption {
      type = types.str;
      description = "The user under which the server runs.";
      default = config.vital.mainUser;
      example = "MyUserName";
    };

    workspace = mkOption {
      type = types.str;
      description = ''
        This specifies the path to the workspace of the Jupyter lab instance.

        The workspace is the top-level directory of all Jupyter projects.
      '';
      default = "/home/${config.vital.mainUser}";
      example = "/home/MyUserName";
    };

    hashedPassword = mkOption {
      type = types.str;
      description = ''
        By default no password is set (empty string).

        If you want to protect your jupyter lab with a password, it is
        highly recommended to set a sha1 password here. A hash of your
        desired password can be obtained by calling the following in
        python

        from notebook.auth import passwd
        In [2]: passwd()
      '';
      default = "";
      example = "sha1:b30990a0275a:b125ac032e3da91c00fc5f5d6fb2f6b66dd00989";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.jupyter-lab =
      let pythonWithBatteries = pkgs.callPackage ../../pkgs/dev/python-with-batteries.nix {
          }; in {
            description = "Long running Jupyter lab server.";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];

            serviceConfig = {
              Type = "simple";
              User = cfg.user;
              Group = "users";
              WorkingDirectory = cfg.workspace;
              ExecStart = ''
                ${pythonWithBatteries}/bin/jupyter lab --port 8888 --ip 0.0.0.0 \
                  --LabApp.token="" --LabApp.password="${cfg.hashedPassword}"
              '';
            };
          };
  };
}
