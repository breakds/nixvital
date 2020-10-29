{ config, pkgs, lib, ... }:

let opencr-udev = pkgs.writeTextFile {
      name = "opencr-udev-rules";
      executable = false;
      destination = "/etc/udev/rules.d/99-opencr-cdc.rules";
      text = ''
        # http://linux-tips.org/t/prevent-modem-manager-to-capture-usb-serial-devices/284/2.
        # cp rules /etc/udev/rules.d/
        # sudo udevadm control --reload-rules
        # sudo udevadm trigger

        ATTRS{idVendor}=="0483" ATTRS{idProduct}=="5740", ENV{ID_MM_DEVICE_IGNORE}="1", MODE:="0666"
        ATTRS{idVendor}=="0483" ATTRS{idProduct}=="df11", MODE:="0666"
        ATTRS{idVendor}=="fff1" ATTRS{idProduct}=="ff48", ENV{ID_MM_DEVICE_IGNORE}="1", MODE:="0666"
        ATTRS{idVendor}=="10c4" ATTRS{idProduct}=="ea60", ENV{ID_MM_DEVICE_IGNORE}="1", MODE:="0666"
      '';
    };

in {
  environment.systemPackages = with pkgs; [
    arduino
  ];

  # Need special udev rules for OpenCR board.
  # See https://emanual.robotis.com/docs/en/parts/controller/opencr10/#usb-port-settings
  services.udev.packages = [ opencr-udev ];
}
