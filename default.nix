let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/06278c77b5d162e62df170fec307e83f1812d94b.tar.gz";
  pkgs = import nixpkgs { };
  mkVersions = pkgs.callPackage ./mkversions.nix { };
  mkVersions' = mkVersions.override { callPackage = mkPackage; };

  # mkPackage = pkgs.callPackage;
  # mkPackage = pkgs.clangStdenv.callPackage;
  mkPackage = pkgs.callPackage.override { stdenv = pkgs.clangStdenv; };
in

mkVersions' {
  package = ./hello.nix;
  versions = import ./versions.nix;
}
