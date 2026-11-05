{
  lib,
  stdenvNoCC,
  fetchurl,
  callPackage,
}:
let
  version = "0.9.5";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/herdrdev/herdr/releases/download/v${version}/herdr-linux-x86_64";
      hash = "sha256-FNnovItKngEY13wyJm921GHwm0A0LrI3UpYL2J9Zkp0=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/herdrdev/herdr/releases/download/v${version}/herdr-macos-aarch64";
      hash = "sha256-+3fCIyoFqANUITgsiUOS9BdOTjihjkivPdApAVfDp+I=";
    };
  };
  system = stdenvNoCC.hostPlatform.system;
in
stdenvNoCC.mkDerivation {
  pname = "herdr-bin";
  inherit version;

  src = sources.${system} or (throw "herdr-bin: unsupported system ${system}");

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/herdr
    runHook postInstall
  '';

  passthru.updateScript = [
    (lib.getExe (callPackage ../../scripts/updater/update-package.nix { }))
    "github"
    "packages/herdr-bin/default.nix"
    "herdrdev/herdr"
  ];

  meta = {
    description = "herdr prebuilt binary";
    homepage = "https://github.com/herdrdev/herdr";
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "herdr";
  };
}
