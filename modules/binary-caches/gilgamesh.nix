# If for some reason this cache is down, you can use the following
# command to force using the official binary cache.
#
#    $ sudo nixos-rebuild switch --fallback --option binary-caches https://cache.nixos.org/
{ config, lib, ... }:

{
  nix.binaryCaches = [ "https://cache.breakds.org/" ];
  nix.binaryCachePublicKeys = [ "cache.breakds.org:BGQP7fAEvtQjuEWnRxR1+VmK38Bwe4yHjtHnpcznSC8=" ];
}
