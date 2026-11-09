{
  lib,
  stdenvNoCC,
  fetchurl,
  libarchive,
  callPackage,
}:
let
  version = "0.8.0";
in
stdenvNoCC.mkDerivation {
  pname = "omniwm-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/OmniNull/OmniWM/releases/download/v${version}/OmniWM-v${version}.zip";
    hash = "sha256-b3+z4hHeOoPncrExgAaAyz0g1MY4gRofAhIP0iXwPMc=";
  };

  sourceRoot = "OmniWM.app";

  # bsdtar preserves the .app code signature; unzip does not.
  unpackCmd = ''
    bsdtar -xf "$curSrc"
  '';

  nativeBuildInputs = [ libarchive ];

  dontStrip = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications $out/bin
    cp -R . $out/Applications/OmniWM.app
    ln -s $out/Applications/OmniWM.app/Contents/MacOS/OmniWM $out/bin/OmniWM
    ln -s $out/Applications/OmniWM.app/Contents/MacOS/omniwmctl $out/bin/omniwmctl
    runHook postInstall
  '';

  passthru.updateScript = [
    (lib.getExe (callPackage ../../scripts/updater/update-package.nix { }))
    "github"
    "packages/omniwm-bin/default.nix"
    "OmniNull/OmniWM"
  ];

  meta = {
    description = "Tiling window manager for macOS with Niri-style scrolling and Dwindle layouts";
    homepage = "https://github.com/OmniNull/OmniWM";
    license = lib.licenses.gpl2Only;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "OmniWM";
  };
}
