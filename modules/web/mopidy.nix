{ config, lib, pkgs, ... } :

{
  services.mopidy = {
    enable = true;
    extensionPackages = [ pkgs.mopidy-iris ];
    dataDir = "/var/lib/mopidy";
    configuration = ''
      [local]
      enabled = true
      library = json
      media_dir = /home/breakds/Music
      scan_timeout = 1000
      scan_flush_threshold = 100
      scan_follow_symlinks = true
      excluded_file_extensions =
        .directory
        .html
        .jpeg
        .jpg
        .log
        .nfo
        .pdf
        .png
        .txt
        .zip
      [audio]
      output = pulsesink server=127.0.0.1
    '';
  };

  # TODO(breakds): Move this to default.nix when done.
  networking.firewall.allowedTCPPorts = [ 6680 ];
}
