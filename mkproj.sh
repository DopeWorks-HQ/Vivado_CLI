#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: $0 <project_name>"
    exit 1
fi

PROJ="$1"

if [ -e "$PROJ" ]; then
    echo "error: project '$PROJ' already exists"
    exit 1
fi

# Create project root
mkdir -p "$PROJ"

# Copy Linux template
cp -r Linux "$PROJ/"

# Create RTL directory
mkdir -p "$PROJ/rtl"

# Stamp project name into template files
find "$PROJ/Linux" -type f -print0 | while IFS= read -r -d '' f; do
    sed -i "s/@PROJECT@/$PROJ/g" "$f"
done

echo "Project '$PROJ' created."
echo "Next steps:"
echo "  cd $PROJ"
echo "  put RTL in rtl/"
echo "  run: Linux/findrtl.sh"
