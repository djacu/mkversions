let
  # arbitrary version, just for demo purposes
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/06278c77b5d162e62df170fec307e83f1812d94b.tar.gz";
  pkgs = import nixpkgs { };

  # you can use this...
  mkVersions = pkgs.callPackage ./mkversions.nix { };

  # or, for instance, override things in it
  mkVersions' = mkVersions.override {
    inherit
      (pkgs.lib.makeScope pkgs.newScope (_: {
        stdenv = pkgs.clang11Stdenv;
      }))
      callPackage
      ;
  };
in

mkVersions' {
  package = ./hello.nix;
  versions = ./versions.json;
}
