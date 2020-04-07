# FIXME: Make this more automatic
#
# Run `idevicepair pair` to pair iphone. You may need to run this
# command twice because the very first attempt will end up prompting
# "trust this device" window on your iphone.
#
# Once paired, you do not have to run this command again when you
# unplug and plug the iphone again.
#
# Use the command `ifuse` to mount the filesystem of iphone to a
# directory. e.g. `ifuse /media/iphone`.

{ config, lib, pkgs, ... }:

let user = config.vital.mainUser;

in {
  environment.systemPackages = [
    pkgs.libimobiledevice
    pkgs.ifuse
  ];

  services.usbmuxd.enable = true;
  services.usbmuxd.user = user;
}
