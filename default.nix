let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/06278c77b5d162e62df170fec307e83f1812d94b.tar.gz";
  pkgs = import nixpkgs { };

  mkVersions = pkgs.callPackage ./mkversions.nix { };

  # Example that overrides stdenv.
  mkVersions' = mkVersions.override {
    inherit (pkgs.lib.makeScope pkgs.newScope (_: { stdenv = pkgs.clang13Stdenv; })) callPackage;
  };
in

mkVersions' {
  package = ./hello.nix;
  versions = import ./versions.nix;
}
