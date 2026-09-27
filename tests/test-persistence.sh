#!/bin/bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
helper="$repo/bin/omarchy-brightness-extra-dark"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin" "$tmp/state"
log="$tmp/calls"

cat >"$tmp/bin/omarchy-brightness-display" <<'EOF'
#!/bin/bash
printf 'brightness %s\n' "$*" >>"$TEST_CALLS"
EOF
cat >"$tmp/bin/hyprctl" <<'EOF'
#!/bin/bash
printf 'hyprctl %s\n' "$*" >>"$TEST_CALLS"
if [[ "$*" == "hyprsunset gamma" ]]; then
  printf '%s\n' "${TEST_CURRENT_GAMMA:-100}"
fi
EOF
cat >"$tmp/bin/omarchy-osd" <<'EOF'
#!/bin/bash
exit 0
EOF
cat >"$tmp/bin/systemctl" <<'EOF'
#!/bin/bash
exit 1
EOF
cat >"$tmp/bin/systemd-run" <<'EOF'
#!/bin/bash
printf 'systemd-run %s\n' "$*" >>"$TEST_CALLS"
EOF
chmod +x "$tmp/bin/"*

export PATH="$tmp/bin:$PATH"
export XDG_STATE_HOME="$tmp/state"
export TEST_CALLS="$log"

"$helper" --no-osd --monitor DP-1 11% >/dev/null
[[ "$(cat "$tmp/state/omarchy/brightness-extra-dark/desired-gamma")" == 55 ]]
grep -q '^systemd-run .*--watch-gamma' "$log"

: >"$log"
TEST_CURRENT_GAMMA=100 "$helper" --watch-gamma-once >/dev/null
grep -q '^hyprctl hyprsunset gamma$' "$log"
grep -q '^hyprctl hyprsunset gamma 55$' "$log"

: >"$log"
TEST_CURRENT_GAMMA=55 "$helper" --watch-gamma-once >/dev/null
if grep -q '^hyprctl hyprsunset gamma 55$' "$log"; then
  echo 'watcher rewrote an already-correct gamma' >&2
  exit 1
fi

printf 'persistence tests passed\n'
