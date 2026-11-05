{
  writeShellApplication,
  coreutils,
  curl,
  jq,
}:
writeShellApplication {
  name = "update-package";
  runtimeInputs = [
    coreutils
    curl
    jq
  ];
  excludeShellChecks = [ "SC2016" ];
  text = builtins.readFile ./update.sh;
}
