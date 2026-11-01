{
  lib,
  stdenvNoCC,
  fetchurl,
  writers,
  installShellFiles,
}:
let
  version = "2026.10.25";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-linux-x64-musl.tar.gz";
      hash = "sha256-G8spE5agAsth2QlNuw0GR0q8PfTRq04f31ncZpynNQY=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-linux-arm64-musl.tar.gz";
      hash = "sha256-hYS9mn6Aq0byCrz69tC5ob0hb7qougDFiogUtHpWU0Y=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-macos-x64.tar.gz";
      hash = "sha256-KzGvwe93xGv5ywg326k2atdE9FI0Og+LANPfHu+JL4Q=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-macos-arm64.tar.gz";
      hash = "sha256-d0I24yR+SNeAeMC8555TJ9TkR58alMhIeCfxeBl+45s=";
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
