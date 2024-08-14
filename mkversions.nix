{ lib, callPackage }:
{ package, versions }@args:
lib.recurseIntoAttrs (
  builtins.mapAttrs (
    version: pkgArgs: callPackage package (pkgArgs // { inherit (pkgArgs) version; })
  ) versions
)
