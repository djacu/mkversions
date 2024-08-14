{ lib, callPackage }:

{ package, versions }:

let
  mkVersionName = version: lib.concatStringsSep "_" (lib.splitVersion version);
in
lib.recurseIntoAttrs (
  lib.mapAttrs' (
    version: info:
    lib.nameValuePair
    (info.version or (mkVersionName version))
    (callPackage package { versionInfo = info // { inherit version; }; })
  ) versions
)
