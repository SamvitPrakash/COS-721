#!/bin/bash

export BASE="$PWD"
export SRC="$BASE/dataset"
export WORK="$BASE/custom_marks"
export OBS="$BASE/environment"

# echo
echo "--- Locus 5: %PDF-1.6 specification style ---"

PDF_1_6_Present="$OBS/marks/pdf-1.6-present"
PDF_1_6_Absent="$OBS/marks/pdf-1.6-absent"


# Indirect: /ID [ ... ] followed by object-number generation-number R
grep -laP '%PDF-1.6' "$SRC"/*.pdf 2>/dev/null \
  | sed 's|.*/||' | cut -c1-5 | sort -u > "$PDF_1_6_Present"

# Direct: everything else (pure-direct + the 8 absent docs)
( cd "$OBS" && ./minus all "$PDF_1_6_Present" ) | sort > "$PDF_1_6_Absent"

printf 'pdf-1.6-present  : %4d documents\n' "$(wc -l < "$PDF_1_6_Present")"
printf 'pdf-1.6-absent   : %4d documents\n' "$(wc -l < "$PDF_1_6_Absent")"
printf 'union              : %4d (must be 1000)\n' \
  "$(cd "$OBS" && ./union "$PDF_1_6_Present" "$PDF_1_6_Absent" | wc -l)"

cp "$PDF_1_6_Present" "$PDF_1_6_Absent" "$WORK"