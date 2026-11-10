{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  libxcb,
  callPackage,
}:
let
  version = "1.5.2";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/earendil-works/pi/releases/download/v${version}/pi-linux-x64.tar.gz";
      hash = "sha256-gRxvLJ56ruJStUBCUuVW+3E6ognB9/kkImqnfU73DLU=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/earendil-works/pi/releases/download/v${version}/pi-darwin-arm64.tar.gz";
      hash = "sha256-VrXhlNSFztVVZnuLoydhV6gnLp7N6eAB5CivgJhb3Zs=";
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

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ libxcb ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/pi $out/bin
    cp -r . $out/lib/pi
    ln -s $out/lib/pi/pi $out/bin/pi
    runHook postInstall
  '';

  passthru.updateScript = [
    (lib.getExe (callPackage ../../scripts/updater/update-package.nix { }))
    "github"
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
