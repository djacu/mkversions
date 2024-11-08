{ lib, callPackage }:

{ package, versions }:

let
  mkVersionName = version: lib.concatStringsSep "_" (lib.splitVersion version);
  resolvedVersions =
    if builtins.isPath versions then
      if lib.hasSuffix ".json" versions then
        builtins.fromJSON (builtins.readFile versions)
      else
        import versions
    else
      versions;
in
lib.recurseIntoAttrs (
  lib.mapAttrs' (
    version: info:
    lib.nameValuePair (info.version or (mkVersionName version)) (
      callPackage package {
        versionInfo = info // {
          inherit version;
        };
      }
    )
  ) resolvedVersions
)
