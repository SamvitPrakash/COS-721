#!/bin/bash

export BASE="$PWD"
export SRC="$BASE/dataset"
export WORK="$BASE/custom_marks"
export OBS="$BASE/environment"

echo "--- Locus 10: xref specification style ---"

xref_present="$OBS/marks/xref_present"
xref_absent="$OBS/marks/xref_absent"

# Indirect: /BleedBox [ ... ] followed by object-number generation-number R
grep -laP '\s+xref' "$SRC"/*.pdf 2>/dev/null \
  | sed 's|.*/||' | cut -c1-5 | sort -u > "$xref_present"

# Direct: everything else (pure-direct + the 8 absent docs)
( cd "$OBS" && ./minus all "$xref_present" ) | sort > "$xref_absent"

printf 'xref_present  : %4d documents\n' "$(wc -l < "$xref_present")"
printf 'xref_absent   : %4d documents\n' "$(wc -l < "$xref_absent")"
printf 'union              : %4d (must be 1000)\n' \
  "$(cd "$OBS" && ./union "$xref_present" "$xref_absent" | wc -l)"

cp "$xref_present" "$xref_absent" "$WORK"