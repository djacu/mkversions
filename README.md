# mkversions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL
NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and
"OPTIONAL" in this document are to be interpreted as described in
[RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119).

To declare a package with multiple versions, the `mkVersions` stdenv
function SHOULD be used. This function takes two attributes:
`package` and `versions`:

- `package` MUST be a path or function compatible with `callPackage`.
- `versions` MUST be a path to a JSON or Nix file,
  attribute set, or expression evaluating to an attribute set, mapping
  versions to _version attribute sets_ defining options specific to each version.

Note that `versions` SHOULD be either a Nix or JSON file and SHOULD NOT
be defined inline to the file in which mkVersions is used.

Each version attribute set MAY have the special key `version`.
All other keys are user-defined.

`mkVersions` MUST return an attribute set mapping _normalized_ version names
to another attribute set containing the key `version` (set to the key in the
`versions` attribute set).

The _normalized_ version name is either the value of the key "version" in the
version attribute set, or the result of joining lib.splitVersion
with underscores.

## Example

Enough words, how does it look?

### default.nix

```nix
{ mkVersions }:

mkVersions {
  package = ./hello.nix;
  versions = ./versions.nix;
}
```

### hello.nix

```nix
{
  stdenv,
  fetchurl,
  versionInfo
}:

stdenv.mkDerivation {
  pname = "hello";
  inherit (versionInfo) version;

  src = fetchurl {
    url = "mirror://gnu/hello/hello-${versionInfo.version}.tar.gz";
    inherit (versionInfo) hash;
  };
}
```

### versions.nix

```nix
  "2.12.1" = {
    hash = "sha256-jZkUKv2SV28wsM18tCqNxoCZmLxdYH2Idh9RLibH2yA=";
    version = "hello_2_12_1";
  };
  "2.12" = {
    hash = "sha256-zwSvhtwIUmjF9EcPuuSbGK+8Iht4CWqrhC2TSna60Ks=";
  };
  "2.10" = {
    hash = "sha256-MeBmE3qWJnbon2nRtlOC3pWn732RS4y5VvQepy4PUWs=";
  };
  "2.9" = {
    hash = "sha256-7Lt6IhQZbFf/k0CqcUWOFVmr049tjRaWZoRpNd8ZHqc=";
  };
}
```

This creates an attribute set shaped like:

```nix
recurseIntoAttrs {
  hello_2_12_1 = callPackage ./hello.nix {
    versionInfo = {
      version = "2.12.1";
      sha256 = "sha256-jZkUKv2SV28wsM18tCqNxoCZmLxdYH2Idh9RLibH2yA=";
    };
  };
  "2_12" = callPackage ./hello.nix {
    versionInfo = {
      version = "2.12";
      hash = "sha256-zwSvhtwIUmjF9EcPuuSbGK+8Iht4CWqrhC2TSna60Ks=";
    };
  };
  "2_10" = callPackage ./hello.nix {
    versionInfo = {
      version = "2.10";
      hash = "sha256-MeBmE3qWJnbon2nRtlOC3pWn732RS4y5VvQepy4PUWs=";
    };
  };
  "2_9" = callPackage ./hello.nix {
    versionInfo = {
      version = "2.9";
      hash = "sha256-7Lt6IhQZbFf/k0CqcUWOFVmr049tjRaWZoRpNd8ZHqc=";
    };
  };
}
```

Which can then be build with `nix-build -A hello_2_12_1` or `nix-build -A 2_12`.
