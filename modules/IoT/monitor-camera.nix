# When enabled, all you need to do is run "motion"

{ config, lib, pkgs, ... } :

let cfg = config.bds.monitor-camera;

in {
  options.bds.monitor-camera = with lib; {
    enable = mkEnableOption "Enable the motion monitoring camera";

    # TODO(breakds): Add a rule to create this directory, maybe just in the upload script?
    clipDir = mkOption {
      type = types.str;
      description = ''
        The path to the directory where the movieclips are stored.
        The daemon in systemd will check for new files and upload them.
      '';
    };

    device = mkOption {
      type = types.str;
      default = "/dev/video0";
      description = ''
        The camera device to be used.
      '';
    };

    fps = mkOption {
      type = types.int;
      default = 15;
      description = ''
        The framerate of the recorded movieclips.
      '';
    };

    sshKey = mkOption {
      type = types.str;
      default = "/home/breakds/.ssh/breakds_samaritan";
      example = "/home/breakds/.ssh/breakds_samaritan";
      description = ''
        Use this ssh key.
      '';
    };

    remoteHost = mkOption {
      type = types.str;
      default = "breakds@gilgamesh";
      example = "breakds@gilgamesh";
      description = ''
        The remote host that will ssh to.
      '';
    };

    remoteDir = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "~/Downlaods";
      description = ''
        The path to the remote directory where movieclips are uploaded to.
        If set to empty, no uploading will be done.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO(breakds): Make this (moiton) a systemd service as well.
    environment.systemPackages = (
      let config-file = pkgs.writeTextFile {
            name = "motion-config-file";
            executable = false;
            destination = "/etc/motion.conf";
            text = ''
              videodevice ${cfg.device}
              text_left Home
              target_dir ${cfg.clipDir}
              webcam_port 5752
              movie_filename %Y.%m.%d.%H.%M.%S
              framerate ${toString cfg.fps}
            '';
          };

          motion-with-config = pkgs.symlinkJoin {
            name = "motion-with-config";
            paths = [ pkgs.motion config-file ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/motion \
                --add-flags "-c $out/etc/motion.conf"
            '';
          };
      in [ motion-with-config ]
    );

    systemd = lib.mkIf (cfg.remoteDir != null) {
      services.upload-motion-clips = {
        description = "Check for movieclips in a directory and upload them.";
        serviceConfig.Type = "oneshot";
        script = ''
          current_epoch=$(date "+%s")
          for f in $(ls ${cfg.clipDir}); do
            file=${cfg.clipDir}/$f

            # Ignore files that are too fresh
            IFS=. read year month day hour minute second<<EOF
          ''${f%.*}
          EOF
            file_epoch=$(date --date="$year-$month-$day $hour:$minute:$second" "+%s")
            let diff_seconds=''${current_epoch}-''${file_epoch}
            if [ ''${diff_seconds} -le 60 ]; then
              echo "[info] Skip $file because it is too fresh"
              continue
            fi

            # Create the date directory
            target_dir=${cfg.remoteDir}/$year.$month.$day
            ${pkgs.openssh}/bin/ssh -o StrictHostKeyChecking=no \
                -i ${cfg.sshKey} ${cfg.remoteHost} \
                "mkdir -p ''${target_dir}"
            if [ "$?" -ne "0" ]; then
              echo "[FAIL] Cannot create remote directory at ''${target_dir}"
              continue
            fi

            # Upload the file
            ${pkgs.openssh}/bin/scp -o StrictHostKeyChecking=no \
                -i ${cfg.sshKey} $file ${cfg.remoteHost}:''${target_dir}
            if [ "$?" -eq "0" ]; then
              # Remove the file if upload is successful
              rm $file
              echo "[ ok ] Successfully uploaded $file"
            else
              echo "[FAIL] uploading $file encounters error"
            fi
          done
        '';
      };
      timers.upload-motion-clips = {
        wantedBy = [ "timers.target" ];
        partOf = [ "upload-motion-clips.service" ];
        # Sync every minute
        timerConfig.OnCalendar = "*:0/1";
      };
    };
  };
}
