{
  stdenv,
  fetchurl,
  version,
  sha256,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hello";
  inherit version;

  src = fetchurl {
    url = "mirror://gnu/hello/hello-${finalAttrs.version}.tar.gz";
    inherit sha256;
  };
})
