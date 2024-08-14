{
  stdenv,
  fetchurl,
  versionInfo
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hello";
  inherit (versionInfo) version;

  src = fetchurl {
    url = "mirror://gnu/hello/hello-${finalAttrs.version}.tar.gz";
    inherit (versionInfo) sha256;
  };
})
