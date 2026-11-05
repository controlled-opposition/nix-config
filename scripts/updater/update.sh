usage="usage: update-package <github|claude|herdr-app> <file> [owner/repo]"

die() {
  printf '%s\n' "${file:+$file: }$*" >&2
  exit 1
}

fetch() {
  curl --fail --silent --show-error --location --max-time 30 \
    --header "User-Agent: nix-config-updater" "$@" || die "failed to fetch ${*: -1}"
}

query() {
  local out
  out=$(jq --raw-output "$@" 2>&1) || die "${out#jq: error (at *): }"
  printf '%s\n' "$out"
}

sri() {
  [[ $1 =~ ^[0-9a-fA-F]{64}$ ]] || die "invalid sha256 checksum: $1"
  local bytes='' i
  for ((i = 0; i < 64; i += 2)); do bytes+="\\x${1:i:2}"; done
  printf 'sha256-%s' "$(printf '%b' "$bytes" | base64)"
}

set_value() {
  local before=$1 after=$2 value=$3 match prefix
  [[ $source =~ ("$before"[[:space:]]*"$after")[^\"]+ ]] || die "no match for: $before $after"
  match=${BASH_REMATCH[0]} prefix=${BASH_REMATCH[1]}
  if [[ ${source#*"$match"} =~ "$before"[[:space:]]*"$after"[^\"]+ ]]; then
    die "more than one match for: $before $after"
  fi
  source=${source/"$match"/"$prefix$value"}
}

github() {
  local repo=$1 rest=$source names=() headers=(--header "Accept: application/vnd.github+json")
  while [[ $rest =~ /releases/download/v'${version}'/([^\"]+)\" ]]; do
    names+=("${BASH_REMATCH[1]}")
    rest=${rest#*"${BASH_REMATCH[0]}"}
  done
  ((${#names[@]})) || die "no release assets found in source"
  if [[ -n ${GITHUB_TOKEN:-} ]]; then
    headers+=(--header "Authorization: Bearer $GITHUB_TOKEN")
  fi
  fetch "${headers[@]}" "https://api.github.com/repos/$repo/releases/latest" |
    query --arg repo "$repo" '
      (.tag_name // "" | ltrimstr("v")) as $version
      | $version,
        ($ARGS.positional[] as $name
          | ($name | gsub("\\$\\{version\\}"; $version)) as $file
          | [.assets[]? | select(.name == $file)] as $assets
          | ($assets[0].digest // "") as $digest
          | if ($assets | length) == 1 and ($digest | startswith("sha256:"))
            then "/\($name)\t\($digest[7:])"
            else error("\($repo): no sha256 digest for \($file)")
            end)
    ' --args "${names[@]}"
}

claude() {
  local base=https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases
  local version
  version=$(fetch "$base/latest")
  [[ $version =~ ^[0-9][0-9A-Za-z.+_-]*$ ]] || die "invalid release version: $version"
  printf '%s\n' "$version"
  fetch "$base/$version/manifest.json" |
    query '.platforms as $p | ("linux-x64", "darwin-arm64") | "/\(.)/claude\t\($p[.].checksum // "")"'
}

herdr_app() {
  local base=https://releases.herdr.dev/app
  fetch "$base/latest.json" |
    query --arg base "$base" '
      .version as $version
      | $version,
        (.targets as $targets
          | ("linux-x86_64", "macos-aarch64")
          | "/herdr-app-\(.).tar.gz" as $suffix
          | if $targets[.].url == "\($base)/\($version)\($suffix)"
            then "\($suffix)\t\($targets[.].sha256 // "")"
            else error("herdr-app-bin: unexpected URL for \(.)")
            end)
    '
}

case ${1:-}:$# in
  github:3 | claude:2 | herdr-app:2) ;;
  *) die "$usage" ;;
esac

file=$(realpath "$2")
IFS= read -rd '' source <"$file" || true
original=$source

case $1 in
  github) rows=$(github "$3") label=$3 ;;
  claude) rows=$(claude) label=claude-code-bin ;;
  herdr-app) rows=$(herdr_app) label=herdr-app-bin ;;
esac

{
  read -r version
  [[ $version =~ ^[0-9][0-9A-Za-z.+_-]*$ ]] || die "invalid release version: $version"
  while IFS=$'\t' read -r suffix checksum; do
    set_value "$suffix\";" 'hash = "' "$(sri "$checksum")"
  done
} <<<"$rows"
set_value 'version = "' '' "$version"

if [[ $source != "$original" ]]; then
  tmp=$(mktemp "${file%/*}/.update-XXXXXX")
  trap 'rm -f "$tmp"' EXIT
  printf '%s' "$source" >"$tmp"
  chmod --reference="$file" "$tmp"
  mv "$tmp" "$file"
fi

printf '%s: %s\n' "$label" "$version"
