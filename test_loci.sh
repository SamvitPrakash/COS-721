#!/bin/bash

export BASE="$PWD"
export SRC="$BASE/dataset"
export WORK="$BASE/custom_marks"
export OBS="$BASE/environment"
# '/Tabs/S/StructParents 0'
# echo
echo "--- Locus n: Base encoding specification style ---"

n_present="$OBS/marks/n_present"
n_absent="$OBS/marks/n_absent"



# Indirect: /BleedBox [ ... ] followed by object-number generation-number R
grep -laP '/Group' "$SRC"/*.pdf 2>/dev/null \
  | sed 's|.*/||' | cut -c1-5 | sort -u > "$n_present"

# Direct: everything else (pure-direct + the 8 absent docs)
( cd "$OBS" && ./minus all "$n_present" ) | sort > "$n_absent"

printf 'n_present  : %4d documents\n' "$(wc -l < "$n_present")"
printf 'n_absent   : %4d documents\n' "$(wc -l < "$n_absent")"
printf 'union              : %4d (must be 1000)\n' \
  "$(cd "$OBS" && ./union "$n_present" "$n_absent" | wc -l)"

cp "$n_present" "$n_absent" "$WORK"