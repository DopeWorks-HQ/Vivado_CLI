#!/usr/bin/env bash
set -e

OUT="synth.tcl"
TMP="$(mktemp)"

# Read existing file, or create it

EXISTING=""
if [ -f "$OUT" ]; then
    EXISTING="$(cat "$OUT")"
fi

# generate new read_verilog lines (only if not already present)

find ../rtl -type f \( -name "*.v" -o -name "*.sv" \) | sort | while read -r f; do
    f="${f#./}"
    case "$f" in
        *.sv) line="read_verilog -sv $f" ;;
        *.v)  line="read_verilog $f" ;;
    esac

    # Only emit if line does NOT already exist
    if ! grep -Fxq "$line" <<< "$EXISTING"; then
        echo "$line"
    fi
done > "$TMP"

# if we added nothing, exit quietly

if [ ! -s "$TMP" ]; then
    echo "No new files to add."
    rm -f "$TMP"
    exit 0
fi

# add blank line
echo >> "$TMP"

# append original contents (unchanged)
if [ -f "$OUT" ]; then
    cat "$OUT" >> "$TMP"
fi

# replace file
mv "$TMP" "$OUT"

echo "Updated $OUT"
