{
  lib,
  stdenvNoCC,
  fetchurl,
  callPackage,
  installShellFiles,
}:
let
  version = "2026.11.7";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-linux-x64-musl.tar.gz";
      hash = "sha256-5g5UqsqQ4jRjzWl9fJyVhY2QGYNy8V75XjCq4bYv7Us=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-macos-arm64.tar.gz";
      hash = "sha256-kvG59otgMan3eTig/439enf+nNkYxbCdDtQ08G670/I=";
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
    (lib.getExe (callPackage ../../scripts/updater/update-package.nix { }))
    "github"
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
