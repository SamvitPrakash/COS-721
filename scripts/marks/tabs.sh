#!/bin/bash

export BASE="$PWD"
export SRC="$BASE/dataset"
export WORK="$BASE/custom_marks"
export OBS="$BASE/environment"

# echo
echo "--- Locus n: Base encoding specification style ---"

tabs_present="$OBS/marks/tabs_present"
tabs_absent="$OBS/marks/tabs_absent"



# Indirect: /BleedBox [ ... ] followed by object-number generation-number R
grep -laP '/Tabs' "$SRC"/*.pdf 2>/dev/null \
  | sed 's|.*/||' | cut -c1-5 | sort -u > "$tabs_present"

# Direct: everything else (pure-direct + the 8 absent docs)
( cd "$OBS" && ./minus all "$tabs_present" ) | sort > "$tabs_absent"

printf 'tabs_present  : %4d documents\n' "$(wc -l < "$tabs_present")"
printf 'tabs_absent   : %4d documents\n' "$(wc -l < "$tabs_absent")"
printf 'union              : %4d (must be 1000)\n' \
  "$(cd "$OBS" && ./union "$tabs_present" "$tabs_absent" | wc -l)"

cp "$tabs_present" "$tabs_absent" "$WORK"