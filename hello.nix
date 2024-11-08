{
  stdenv,
  fetchurl,
  versionInfo,
}:

stdenv.mkDerivation {
  pname = "hello";
  inherit (versionInfo) version;

  src = fetchurl {
    url = "mirror://gnu/hello/hello-${versionInfo.version}.tar.gz";
    inherit (versionInfo) hash;
  };
}
