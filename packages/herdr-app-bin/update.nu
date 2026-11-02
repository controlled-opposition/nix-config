def main [file: path] {
  let manifest = http get https://releases.herdr.dev/app/latest.json
  let version = $manifest.version
  let updated = [linux-x86_64 linux-aarch64 macos-aarch64]
  | reduce --fold (open --raw $file) {|target, text|
    let release = $manifest.targets | get $target
    let expected = $"https://releases.herdr.dev/app/($version)/herdr-app-($target).tar.gz"
    if $release.url != $expected {
      error make {msg: $"herdr-app-bin: unexpected URL for ($target)"}
    }
    let hash = $release.sha256 | decode hex | encode base64
    let pattern = '(/herdr-app-' + $target + '\.tar\.gz";\s*hash = ")[^"]+'
    $text | str replace --regex $pattern ('${1}sha256-' + $hash)
  }
  | str replace --regex 'version = "[^"]+"' $'version = "($version)"'

  $updated | save --force $file
  print $"herdr-app-bin: ($version)"
}
