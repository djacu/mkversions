{ lib, callPackage }:
{
  package,
  versions,
  mkPackage ? callPackage package,
}@args:
lib.recurseIntoAttrs (
  lib.mapAttrs' (version: pkgArgs: {
    name = version;
    value = mkPackage (pkgArgs // { inherit version; });
  }) versions
)
