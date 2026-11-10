{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  libxcb,
  callPackage,
}:
let
  version = "1.5.1";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/earendil-works/pi/releases/download/v${version}/pi-linux-x64.tar.gz";
      hash = "sha256-y2mXnAqBYr8ivO4HYvPDcBpFtRtVL6Fqc21GfGBoUJ8=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/earendil-works/pi/releases/download/v${version}/pi-darwin-arm64.tar.gz";
      hash = "sha256-7svuT7thKMYlukT/4wz8FYhKd5HSQgF7qTePV0hZcdU=";
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
