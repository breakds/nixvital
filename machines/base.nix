# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ../modules/top-level-options.nix
      ../modules/security.nix
      ../modules/docker.nix
      ../modules/services/nixvital-reflection.nix
      ../modules/perf.nix
    ];

  # Specifies the overlay for all the packages.
  nixpkgs.overlays = [
    (import ../overlays)
    (import ../overlays/ros)
  ];

  # +------------------------------------------------------------+
  # | Boot Settings                                              |
  # +------------------------------------------------------------+  

  # Boot with UEFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Filesystem Support
  boot.supportedFilesystems = [ "zfs" "ntfs" ];

  # +------------------------------------------------------------+
  # | Default Settings                                           |
  # +------------------------------------------------------------+

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Enable to use non-free packages such as nvidia drivers
  nixpkgs.config.allowUnfree = true;

  # Basic softwares that should definitely exist.
  environment.systemPackages = with pkgs; [
    wget vim emacs firefox google-chrome dmenu scrot inkscape pdftk
    # ---------- System Utils ----------
    rsync pciutils usbutils mkpasswd nixops remmina
    pciutils usbutils mkpasswd nixops remmina p7zip unzip
    arandr smbclient neofetch ffmpeg zstd tmux
    # ---------- Development ----------
    git tig cmake clang clang-tools binutils
    gcc silver-searcher sbcl
    web-dev-tools
    py-dev-tools
    ros2nix
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # TODO(breakds): Figure out how to use GPG.
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # For monitoring and inspecting the system.
  programs.sysdig.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # Enable X11 Fowarding, can be connected with ssh -Y.
    forwardX11 = true;
    allowSFTP = config.vital.machineType == "server";
  };
    
  # Enable CUPS services
  services.printing.enable = true;

  services.udev.packages = [ pkgs.libu2f-host ];

  # Disable UDisks by default (significantly reduces system closure size)
  services.udisks2.enable = lib.mkDefault false;

  # +------------------------------------------------------------+
  # | Network Settings                                           |
  # +------------------------------------------------------------+

  services.avahi = {
    enable = true;
      
    # Whether to enable the mDNS NSS (Name Service Switch) plugin.
    # Enabling this allows applications to resolve names in the
    # `.local` domain.
    nssmdns = true;

    # Whether to register mDNS address records for all local IP
    # addresses.
    publish.enable = true;
    publish.addresses = true;    
  };

  services.blueman.enable = true;

  # +------------------------------------------------------------+
  # | Garbage Collection                                         |
  # +------------------------------------------------------------+

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  # +------------------------------------------------------------+
  # | System files                                               |
  # +------------------------------------------------------------+

  environment.etc = {
    "bashrc.local".source = ../data/bashrc.local;
  };

  # +------------------------------------------------------------+
  # | Other Services                                             |
  # +------------------------------------------------------------+

  vital.nixvital-reflection = {
    enable = lib.mkDefault true;
    show = [
      { key = "system.stateVersion"; val = config.system.stateVersion; }
      { key = "vital.machineType"; val = config.vital.machineType; }
      { key = "vital.mainUser"; val = config.vital.mainUser; }
    ];
  };
}
