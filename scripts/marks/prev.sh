#!/bin/bash

export BASE="$PWD"
export SRC="$BASE/dataset"
export WORK="$BASE/custom_marks"
export OBS="$BASE/environment"

# echo
echo "--- Locus n: Base encoding specification style ---"

prev_present="$OBS/marks/prev_present"
prev_absent="$OBS/marks/prev_absent"



# Indirect: /BleedBox [ ... ] followed by object-number generation-number R
grep -laP '/Prev' "$SRC"/*.pdf 2>/dev/null \
  | sed 's|.*/||' | cut -c1-5 | sort -u > "$prev_present"

# Direct: everything else (pure-direct + the 8 absent docs)
( cd "$OBS" && ./minus all "$prev_present" ) | sort > "$prev_absent"

printf 'prev_present  : %4d documents\n' "$(wc -l < "$prev_present")"
printf 'prev_absent   : %4d documents\n' "$(wc -l < "$prev_absent")"
printf 'union              : %4d (must be 1000)\n' \
  "$(cd "$OBS" && ./union "$prev_present" "$prev_absent" | wc -l)"

cp "$prev_present" "$prev_absent" "$WORK"