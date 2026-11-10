{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  callPackage,
}:
let
  version = "2.1.322";
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  sources = {
    x86_64-linux = fetchurl {
      url = "${baseUrl}/${version}/linux-x64/claude";
      hash = "sha256-v7NwOtU4AkIyhFm8Yq2kveiue6V8bh7q25wA4Ih0xHg=";
    };
    aarch64-darwin = fetchurl {
      url = "${baseUrl}/${version}/darwin-arm64/claude";
      hash = "sha256-qdI3lJ24FqC3r9iKmo4d82s6WXow9aQdHAU56xgKNFA=";
    };
  };
  system = stdenvNoCC.hostPlatform.system;
in
stdenvNoCC.mkDerivation {
  pname = "claude-code-bin";
  inherit version;

  src = sources.${system} or (throw "claude-code-bin: unsupported system ${system}");

  dontUnpack = true;
  dontStrip = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/claude
    wrapProgram $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1 \
      --set DISABLE_INSTALLATION_CHECKS 1
    runHook postInstall
  '';

  passthru.updateScript = [
    (lib.getExe (callPackage ../../scripts/updater/update-package.nix { }))
    "claude"
    "packages/claude-code-bin/default.nix"
  ];

  meta = {
    description = "Claude Code prebuilt binary";
    homepage = "https://github.com/anthropics/claude-code";
    license = lib.licenses.unfree;
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "claude";
  };
}
