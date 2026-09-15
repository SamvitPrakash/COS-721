#!/bin/bash

export BASE="$PWD"
export OBS="$BASE/environment"

OLD="$1"
NEW="$2"

OLD_MARK="$OBS/marks/$OLD"
NEW_MARK="$OBS/marks/$NEW"

echo "======================================================="
echo " COMPARING MARKS"
echo "======================================================="
echo
echo "OLD MARK : $OLD"
echo "NEW MARK : $NEW"
echo

old_count=$(wc -l < "$OLD_MARK")
new_count=$(wc -l < "$NEW_MARK")

both_count=$(cd "$OBS" && ./section "marks/$OLD" "marks/$NEW" | wc -l)

old_only=$(cd "$OBS" && ./minus "marks/$OLD" "marks/$NEW" | wc -l)

new_only=$(cd "$OBS" && ./minus "marks/$NEW" "marks/$OLD" | wc -l)

echo "Old mark documents : $old_count"
echo "New mark documents : $new_count"
echo "Both marks         : $both_count"
echo "Old only           : $old_only"
echo "New only           : $new_only"
echo

echo "-------------------------------------------------------"
echo " Old mark but NOT new"
echo "-------------------------------------------------------"

cd "$OBS" && ./minus "marks/$OLD" "marks/$NEW"

echo

echo "-------------------------------------------------------"
echo " New mark but NOT old"
echo "-------------------------------------------------------"

cd "$OBS" && ./minus "marks/$NEW" "marks/$OLD"

echo
echo "======================================================="