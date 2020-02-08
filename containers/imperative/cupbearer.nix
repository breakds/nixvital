# A cup-bearer was an officer of high rank in royal courts whose duty
# it was to serve the drinks at the royal table. He must guard against
# poison in the king's cup and was sometimes required to swallow some
# of the drink before serving it.
#
#          -- Wikipediea

{ config, lib, pkgs, ... }:

{
  imports = [
    ../container-base.nix
    ../../modules/users
  ];

  networking.hostName = "cupbearer";
}
