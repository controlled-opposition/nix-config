{
  lib,
  python3Packages,
  fetchurl,
  gobject-introspection,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  xdg-utils,
  copyDesktopItems,
  makeDesktopItem,
  callPackage,
}:
python3Packages.buildPythonApplication rec {
  pname = "nutmeg";
  version = "1.2.1";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/frolleks/nutmeg/releases/download/v${version}/nutmeg-${version}.tar.gz";
    hash = "sha256-TLC/6PZUjJdUKcouJV+y3ucwFPkZxMscMz6fJV0XeZU=";
  };

  build-system = [ python3Packages.setuptools ];
  dependencies = [ python3Packages.pygobject3 ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
    copyDesktopItems
  ];
  buildInputs = [
    gtk4
    libadwaita
  ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
    )
  '';

  postInstall = ''
    install -Dm644 nutmeg/data/nutmeg.svg $out/share/icons/hicolor/scalable/apps/nutmeg.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "nutmeg-settings";
      desktopName = "Nutmeg Settings";
      exec = "nutmeg settings";
      icon = "nutmeg";
      categories = [ "Game" ];
    })
    (makeDesktopItem {
      name = "nutmeg";
      desktopName = "Roblox (Nutmeg)";
      exec = "nutmeg launch %u";
      icon = "nutmeg";
      categories = [ "Game" ];
      mimeTypes = [
        "x-scheme-handler/roblox-player"
        "x-scheme-handler/roblox"
      ];
    })
  ];

  pythonImportsCheck = [ "nutmeg" ];

  passthru.updateScript = [
    (callPackage ../update-script.nix { })
    "github"
    "packages/nutmeg/default.nix"
    "frolleks/nutmeg"
  ];

  meta = {
    description = "Roblox bootstrapper using the macOS client through Rosemary";
    homepage = "https://github.com/frolleks/nutmeg";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "nutmeg";
  };
}
