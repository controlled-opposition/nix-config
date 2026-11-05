{
  writeShellScript,
  bun,
}:
writeShellScript "update-package" ''
  exec ${bun}/bin/bun run --no-install ${./update.ts} "$@"
''
