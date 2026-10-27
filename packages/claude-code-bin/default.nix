{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  writers,
}:
let
  version = "2.1.312";
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  sources = {
    x86_64-linux = fetchurl {
      url = "${baseUrl}/${version}/linux-x64/claude";
      hash = "sha256-T0F4zkHYPiM0Hr+67NvPjqa/e66gaQAlq+Se7sOl0B0=";
    };
    aarch64-linux = fetchurl {
      url = "${baseUrl}/${version}/linux-arm64/claude";
      hash = "sha256-3EryiRdFXgCdJnBLgqQ4NToGFJ6CW2zfeCkIstKGYfU=";
    };
    x86_64-darwin = fetchurl {
      url = "${baseUrl}/${version}/darwin-x64/claude";
      hash = "sha256-lTR3DhYs/W45MB2at3Wv/OIU3wMqaEhAhb26uWan+M8=";
    };
    aarch64-darwin = fetchurl {
      url = "${baseUrl}/${version}/darwin-arm64/claude";
      hash = "sha256-a17GkRleVRsCxB3599cj9Oph6qA8LfkKzv43NvGutiA=";
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
    (writers.writeNu "claude-code-bin-update" ./update.nu)
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
