{
  lib,
  stdenvNoCC,
  fetchurl,
  writers,
  installShellFiles,
}:
let
  version = "2026.10.21";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-linux-x64-musl.tar.gz";
      hash = "sha256-Y7ViFGe1uZULmbczOuwbSjTF8jqeRk0zA1fFs1UC6Nc=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-linux-arm64-musl.tar.gz";
      hash = "sha256-m0QHKJfQSJ15uPEt4Tw6JzQuEfhXthSqWMXzR3TA2nU=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-macos-x64.tar.gz";
      hash = "sha256-cihI/AUiqZa8zKNc7vYUs5Jrsa6XsUX+EbsIz5YLMfk=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-macos-arm64.tar.gz";
      hash = "sha256-1ntgBssRRBMZEM6A1s9SE09VucfaVWSL1xffNrPyONY=";
    };
  };
  system = stdenvNoCC.hostPlatform.system;
in
stdenvNoCC.mkDerivation {
  pname = "mise-bin";
  inherit version;

  src = sources.${system} or (throw "mise-bin: unsupported system ${system}");

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/mise $out/bin/mise
    installManPage man/man1/mise.1
    install -Dm644 share/fish/vendor_conf.d/mise-activate.fish $out/share/fish/vendor_conf.d/mise-activate.fish
    runHook postInstall
  '';

  passthru.updateScript = [
    (writers.writeNu "update-github-release" ../update-github-release.nu)
    "packages/mise-bin/default.nix"
    "jdx/mise"
  ];

  meta = {
    description = "mise prebuilt binary";
    homepage = "https://github.com/jdx/mise";
    license = lib.licenses.mit;
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "mise";
  };
}
