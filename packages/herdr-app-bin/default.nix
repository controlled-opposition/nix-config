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
  callPackage,
}:
let
  version = "0.1.14";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://releases.herdr.dev/app/${version}/herdr-app-linux-x86_64.tar.gz";
      hash = "sha256-R1o4P49DnjGRqGY1tcEobOTf0tn83x58vf3Wxxdvj/M=";
    };
    aarch64-darwin = fetchurl {
      url = "https://releases.herdr.dev/app/${version}/herdr-app-macos-aarch64.tar.gz";
      hash = "sha256-DabKIUIUOJyjngX99lI/1uS+QjpL59/Tm2d9aKQQ+os=";
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
    (lib.getExe (callPackage ../../scripts/updater/update-package.nix { }))
    "herdr-app"
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
