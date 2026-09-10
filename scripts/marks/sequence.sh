#!/bin/bash

export BASE="$PWD"
export SRC="$BASE/dataset"
export WORK="$BASE/custom_marks"
export OBS="$BASE/environment"

# echo
echo "--- Locus 4: Sequences specification style ---"

SEQ_Present="$OBS/marks/seq-present"
SEQ_Absent="$OBS/marks/seq-absent"

# Indirect: /Resources followed by object-number generation-number R
grep -laP '/Resources\s+\d+\s+\d+\s+R' "$SRC"/*.pdf 2>/dev/null \
  | sed 's|.*/||' | cut -c1-5 | sort -u > "$SEQ_Present"

# Direct: everything else (pure-direct + the 8 absent docs)
( cd "$OBS" && ./minus all "marks/seq-present" ) | sort > "$SEQ_Absent"

printf 'seq-present : %4d documents\n' "$(wc -l < "$SEQ_Present")"
printf 'seq-absent   : %4d documents\n' "$(wc -l < "$SEQ_Absent")"
printf 'union              : %4d (must be 1000)\n' \
  "$(cd "$OBS" && ./union marks/seq-present marks/seq-absent | wc -l)"

cp "$SEQ_Present" "$SEQ_Absent" "$WORK"