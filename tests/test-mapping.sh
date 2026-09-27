#!/bin/bash
set -euo pipefail

helper="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)/bin/omarchy-brightness-extra-dark"

check() {
  local logical="$1" expected="$2" actual
  actual="$($helper --monitor TEST-1 --map "$logical")"
  [[ "$actual" == "$expected" ]] || {
    printf 'logical %s: expected %s, got %s\n' "$logical" "$expected" "$actual" >&2
    exit 1
  }
}

check 1 '1 5'
check 20 '1 100'
check 21 '2 100'
check 100 '100 100'

printf 'mapping tests passed\n'
