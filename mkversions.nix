{ lib, callPackage }:

{ package, versions }:

lib.recurseIntoAttrs (
  builtins.mapAttrs (
    version: pkgArgs: callPackage package (pkgArgs // { inherit (pkgArgs) version; })
  ) versions
)
