{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  writers,
}:
let
  version = "1.4.0";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/earendil-works/pi/releases/download/v${version}/pi-linux-x64.tar.gz";
      hash = "sha256-8uTkMpYDIj0DJgzbi9UDPb3B9zuliriTnbLlZUbhFdI=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/earendil-works/pi/releases/download/v${version}/pi-linux-arm64.tar.gz";
      hash = "sha256-+lgpx++D/+rrugFXFcgwYiD4myqooAFU77upjdVEAVY=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/earendil-works/pi/releases/download/v${version}/pi-darwin-x64.tar.gz";
      hash = "sha256-G978nhB0wd5Fjqny5D5gE85JzQUyYAmz3hRANwNlheI=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/earendil-works/pi/releases/download/v${version}/pi-darwin-arm64.tar.gz";
      hash = "sha256-edmXnXaipa23wo4n6bRGKZKMzQ3J+7aucheGC9Xovl0=";
    };
  };
  system = stdenvNoCC.hostPlatform.system;
in
stdenvNoCC.mkDerivation {
  pname = "pi-bin";
  inherit version;

  src = sources.${system} or (throw "pi-bin: unsupported system ${system}");

  sourceRoot = "pi";

  dontStrip = true;

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/pi $out/bin
    cp -r . $out/lib/pi
    ln -s $out/lib/pi/pi $out/bin/pi
    runHook postInstall
  '';

  passthru.updateScript = [
    (writers.writeNu "update-github-release" ../update-github-release.nu)
    "packages/pi-bin/default.nix"
    "earendil-works/pi"
  ];

  meta = {
    description = "pi prebuilt binary";
    homepage = "https://github.com/earendil-works/pi";
    license = lib.licenses.mit;
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "pi";
  };
}
