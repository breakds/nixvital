# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ../modules/user.nix
      ../modules/security.nix
      # ../modules/xserver.nix
    ];

  # +------------------------------------------------------------+
  # | Boot Settings                                              |
  # +------------------------------------------------------------+  

  # Boot with UEFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Filesystem Support
  boot.supportedFilesystems = [ "zfs" ];

  # +------------------------------------------------------------+
  # | Default Settings                                           |
  # +------------------------------------------------------------+

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Enable to use non-free packages such as nvidia drivers
  nixpkgs.config.allowUnfree = true;

  # Basic softwares that should definitely exist.
  environment.systemPackages = with pkgs; [
    wget vim emacs firefox google-chrome git
    gnupg pass
    tig # The CLI git interface
    dmenu
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # TODO(breakds): Figure out how to use GPG.
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Enable CUPS services
  services.printing.enable = true;

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

  # +------------------------------------------------------------+
  # | Version Settings                                           |
  # +------------------------------------------------------------+

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
