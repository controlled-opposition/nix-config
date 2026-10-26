def main [file: path, repo: string] {
  let headers = if ($env.GITHUB_TOKEN? | is-not-empty) {
    {Authorization: $"Bearer ($env.GITHUB_TOKEN)"}
  } else {
    {}
  }
  let release = http get --headers $headers $"https://api.github.com/repos/($repo)/releases/latest"
  let version = $release.tag_name | str replace --regex '^v' ''
  let text = open --raw $file

  let updated = $text
  | parse --regex '/releases/download/v\$\{version\}/(?<name>[^"]+)"'
  | get name
  | reduce --fold $text {|name, text|
    let asset = $name | str replace --all '${version}' $version
    let digest = $release.assets | where name == $asset | get --optional 0.digest
    if ($digest | is-empty) or not ($digest | str starts-with "sha256:") {
      error make {msg: $"($repo): no sha256 digest for ($asset)"}
    }
    let hash = $digest | str replace "sha256:" "" | decode hex | encode base64
    let escaped = $name | str replace --all --regex '([.*+?^${}()|\[\]\\])' '\${1}'
    let pattern = '(/' + $escaped + '";\s*hash = ")[^"]+'
    $text | str replace --regex $pattern ('${1}sha256-' + $hash)
  }
  | str replace --regex 'version = "[^"]+"' $'version = "($version)"'

  $updated | save --force $file
  print $"($repo): ($version)"
}
