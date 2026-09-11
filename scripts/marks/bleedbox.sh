#!/bin/bash

export BASE="$PWD"
export SRC="$BASE/dataset"
export WORK="$BASE/custom_marks"
export OBS="$BASE/environment"

# echo
echo "--- Locus 7: BleedBox specification style ---"

bleedbox_present="$OBS/marks/bleedbox_present"
bleedbox_absent="$OBS/marks/bleedbox_absent"


# Indirect: /ID [ ... ] followed by object-number generation-number R
grep -laP '/ID\s+\[(?:<[0-9A-Fa-f]+>\s*)+\]' "$SRC"/*.pdf 2>/dev/null \
  | sed 's|.*/||' | cut -c1-5 | sort -u > "$bleedbox_present"

# Direct: everything else (pure-direct + the 8 absent docs)
( cd "$OBS" && ./minus all "$bleedbox_present" ) | sort > "$bleedbox_absent"

printf 'bleedbox_present  : %4d documents\n' "$(wc -l < "$bleedbox_present")"
printf 'bleedbox_absent   : %4d documents\n' "$(wc -l < "$bleedbox_absent")"
printf 'union              : %4d (must be 1000)\n' \
  "$(cd "$OBS" && ./union "$bleedbox_present" "$bleedbox_absent" | wc -l)"

cp "$bleedbox_present" "$bleedbox_absent" "$WORK"