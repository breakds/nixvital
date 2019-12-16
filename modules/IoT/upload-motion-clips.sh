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
