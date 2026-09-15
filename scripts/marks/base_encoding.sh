#!/bin/bash

export BASE="$PWD"
export SRC="$BASE/dataset"
export WORK="$BASE/custom_marks"
export OBS="$BASE/environment"

# echo
echo "--- Locus 8: Base encoding specification style ---"

encoding_present="$OBS/marks/encoding_present"
encoding_absent="$OBS/marks/encoding_absent"



# Indirect: /BleedBox [ ... ] followed by object-number generation-number R
grep -laP '/WinAnsiEncoding' "$SRC"/*.pdf 2>/dev/null \
  | sed 's|.*/||' | cut -c1-5 | sort -u > "$encoding_present"

# Direct: everything else (pure-direct + the 8 absent docs)
( cd "$OBS" && ./minus all "$encoding_present" ) | sort > "$encoding_absent"

printf 'encoding_present  : %4d documents\n' "$(wc -l < "$encoding_present")"
printf 'encoding_absent   : %4d documents\n' "$(wc -l < "$encoding_absent")"
printf 'union              : %4d (must be 1000)\n' \
  "$(cd "$OBS" && ./union "$encoding_present" "$encoding_absent" | wc -l)"

cp "$encoding_present" "$encoding_absent" "$WORK"