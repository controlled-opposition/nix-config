const base = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"

def main [file: path] {
  let version = http get $"($base)/latest" | str trim
  let manifest = http get $"($base)/($version)/manifest.json"

  let updated = [linux-x64 linux-arm64 darwin-x64 darwin-arm64]
  | reduce --fold (open --raw $file) {|platform, text|
    let hash = $manifest.platforms
    | get $platform
    | get checksum
    | decode hex
    | encode base64
    let pattern = '(/' + $platform + '/claude";\s*hash = ")[^"]+'
    $text | str replace --regex $pattern ('${1}sha256-' + $hash)
  }
  | str replace --regex 'version = "[^"]+"' $'version = "($version)"'

  $updated | save --force $file
  print $"claude-code-bin: ($version)"
}
