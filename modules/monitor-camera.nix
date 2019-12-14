{ config, lib, pkgs, ... } :

let cfg = config.bds.monitor-camera;

in {

  options.bds.monitor-camera = with lib; {
    enable = mkEnableOption "Enable the motion monitoring camera";
    
    clipDir = mkOption {
      type = types.str;
      description = ''
        The path to the directory where the movieclips are stored.
        The daemon in systemd will check for new files and upload them.
      '';
    };

    remoteDir = mkOption {
      type = types.str;
      example = "breakds@gilgamesh:~/Downlaods";
      description = ''
        The path to the remote directory where movieclips are uploaded to.
      '';
    };
  };

  config = {
    # TODO(breakds): Make this (moiton) a systemd service as well.
    environment.systemPackages = with pkgs; [ motion ];
    
    systemd = lib.mkIf cfg.enable {
      services.upload-motion-clips = {
        description = "Check for movieclips in a directory and upload them.";
        serviceConfig.Type = "oneshot";
        script = ''
          for basename in $(ls ${cfg.clipDir}); do
            file=${cfg.clipDir}/$basename
            echo "Uploading $file"
            ${pkgs.openssh}/bin/scp -o StrictHostKeyChecking=no \
                -i /home/breakds/.ssh/breakds_samaritan $file ${cfg.remoteDir}
            if [ "$?" -eq "0" ]; then
              # Remove the file if upload is successful
              rm $file
              echo "[ ok ] Successfully uploaded $file"
            else
              echo "[FAIL] upload $file encounters error"
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
