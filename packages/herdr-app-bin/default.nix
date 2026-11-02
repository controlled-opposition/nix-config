{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  libxcb,
  libxkbcommon,
  libgcc,
  wayland,
  vulkan-loader,
  copyDesktopItems,
  makeDesktopItem,
  writers,
}:
let
  version = "0.1.12";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://releases.herdr.dev/app/${version}/herdr-app-linux-x86_64.tar.gz";
      hash = "sha256-omXmySXEh0WEBnQf+gnS+g09S9QBo07YwBwzYQjlfB8=";
    };
    aarch64-linux = fetchurl {
      url = "https://releases.herdr.dev/app/${version}/herdr-app-linux-aarch64.tar.gz";
      hash = "sha256-dJ8x0w4/TX4k4nSPdNnLSpvdpMloAnq6/7b7I5/+tpQ=";
    };
    aarch64-darwin = fetchurl {
      url = "https://releases.herdr.dev/app/${version}/herdr-app-macos-aarch64.tar.gz";
      hash = "sha256-AGpPaECaeVSNGqbF+Z2okRt9FJEO8qxr0aPc5jTKXQM=";
    };
  };
  system = stdenvNoCC.hostPlatform.system;
in
stdenvNoCC.mkDerivation {
  pname = "herdr-app-bin";
  inherit version;

  src = sources.${system} or (throw "herdr-app-bin: unsupported system ${system}");
  sourceRoot = ".";
  dontStrip = true;

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    autoPatchelfHook
    copyDesktopItems
  ];
  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    libxcb
    libxkbcommon
    libgcc
  ];
  runtimeDependencies = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    wayland
    vulkan-loader
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    ${
      if stdenvNoCC.hostPlatform.isDarwin then
        ''
          mkdir -p $out/Applications
          cp -R Herdr.app $out/Applications/
          ln -s $out/Applications/Herdr.app/Contents/MacOS/Herdr $out/bin/herdr-app
        ''
      else
        ''
          install -Dm755 herdr-app/herdr-app $out/bin/herdr-app
          install -Dm644 herdr-app/herdr-app.svg $out/share/icons/hicolor/scalable/apps/herdr-app.svg
          install -Dm644 herdr-app/LICENSE $out/share/licenses/herdr-app/LICENSE
          install -Dm644 herdr-app/THIRD-PARTY-NOTICES $out/share/licenses/herdr-app/THIRD-PARTY-NOTICES
        ''
    }
    runHook postInstall
  '';

  desktopItems = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "herdr-app";
      desktopName = "Herdr";
      comment = "Terminals and coding agents that keep running";
      exec = "herdr-app";
      icon = "herdr-app";
      categories = [ "Development" ];
      startupWMClass = "herdr-app";
    })
  ];

  passthru.updateScript = [
    (writers.writeNu "update-herdr-app" ./update.nu)
    "packages/herdr-app-bin/default.nix"
  ];

  meta = {
    description = "Desktop app for terminals and coding agents";
    homepage = "https://github.com/herdrdev/herdr-app";
    license = lib.licenses.asl20;
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "herdr-app";
  };
}
