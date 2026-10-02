#!/usr/bin/env bash
# Archive external links in content/ to the Wayback Machine, and replace dead
# links with their latest snapshot.
#
# Usage: scripts/archive-links.sh [-n] [-d delay-seconds]
#   -n  dry run: report dead links and snapshots without saving or editing
#   -d  seconds to wait between Wayback saves (default 10)
set -uo pipefail

cd "$(dirname "$0")/.."

dry_run=false
delay=10
while getopts "nd:" opt; do
  case "$opt" in
    n) dry_run=true ;;
    d) delay="$OPTARG" ;;
    *) exit 2 ;;
  esac
done

ua="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36"

# Only treat a link as dead on a clear signal: not found, gone, or no
# connection at all. Bot blocks (403, 429, LinkedIn's 999) count as alive.
is_dead() {
  local code
  code=$(curl -sL -o /dev/null -w '%{http_code}' -A "$ua" --max-time 20 "$1")
  case "$code" in
    000 | 404 | 410) return 0 ;;
    *) return 1 ;;
  esac
}

latest_snapshot() {
  curl -sG --max-time 30 "https://archive.org/wayback/available" \
    --data-urlencode "url=$1" \
    | jq -r '.archived_snapshots.closest | select(.available and .status == "200") | .url // empty' \
    | sed 's|^http://|https://|'
}

# Replace exact occurrences of a URL, skipping ones already embedded in a
# web.archive.org URL (preceded by "/").
replace_link() {
  local url="$1" snapshot="$2"
  grep -rlF "$url" content | while read -r file; do
    URL="$url" SNAP="$snapshot" perl -pi -e \
      's/(?<!\/)\Q$ENV{URL}\E(?=[\])"> ]|$)/$ENV{SNAP}/g' "$file"
    echo "    updated $file"
  done
}

urls=$(grep -rhoE 'https?://[^] )">]+' content \
  | grep -vE '^https?://(web\.archive\.org|(www\.)?justinwaltrip\.com)' \
  | sort -u)

total=$(wc -l <<<"$urls" | tr -d ' ')
i=0
failed=()
replaced=()
unrecoverable=()

while read -r url; do
  i=$((i + 1))
  echo "[$i/$total] $url"

  if is_dead "$url"; then
    snapshot=$(latest_snapshot "$url")
    if [ -z "$snapshot" ]; then
      echo "  dead, no snapshot found"
      unrecoverable+=("$url")
      continue
    fi
    echo "  dead -> $snapshot"
    replaced+=("$url")
    $dry_run || replace_link "$url" "$snapshot"
    continue
  fi

  $dry_run && continue
  if ! waybackpy --url "$url" --save; then
    failed+=("$url")
  fi
  [ "$i" -lt "$total" ] && sleep "$delay"
done <<<"$urls"

echo
echo "Replaced with snapshot: ${#replaced[@]}"
[ "${#replaced[@]}" -gt 0 ] && printf '  %s\n' "${replaced[@]}"
if [ "${#unrecoverable[@]}" -gt 0 ]; then
  echo "Dead with no snapshot (${#unrecoverable[@]}):"
  printf '  %s\n' "${unrecoverable[@]}"
fi
if [ "${#failed[@]}" -gt 0 ]; then
  echo "Save failed (${#failed[@]}):"
  printf '  %s\n' "${failed[@]}"
fi

[ "${#unrecoverable[@]}" -eq 0 ] && [ "${#failed[@]}" -eq 0 ]
