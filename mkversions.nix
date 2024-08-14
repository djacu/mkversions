{ lib, callPackage }:

{ package, versions }:

lib.recurseIntoAttrs (
  builtins.mapAttrs (
    version: versionInfo: callPackage package { inherit versionInfo; }
  ) versions
)
