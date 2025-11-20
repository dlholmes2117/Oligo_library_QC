#!/usr/bin/env bash
set -euo pipefail

# >>> EDIT THESE <<<
DIR1="20251015_fastqs"   # first directory of fastqs
DIR2="assembled"   # second directory of fastqs

MERGED="merged"
mkdir -p "$MERGED"

# 1) Handle files from DIR1
for f in "$DIR1"/*.fastq*; do
    [ -e "$f" ] || continue   # skip if no matches
    base=$(basename "$f")

    if [ -e "$DIR2/$base" ]; then
        echo "Merging $DIR1/$base and $DIR2/$base -> $MERGED/$base"
        cat "$DIR1/$base" "$DIR2/$base" > "$MERGED/$base"
    else
        echo "Copying $DIR1/$base -> $MERGED/$base"
        cp "$DIR1/$base" "$MERGED/$base"
    fi
done

# 2) Handle files that exist only in DIR2
for f in "$DIR2"/*.fastq*; do
    [ -e "$f" ] || continue
    base=$(basename "$f")

    # if it wasn't already created above, copy it
    if [ ! -e "$MERGED/$base" ]; then
        echo "Copying $DIR2/$base -> $MERGED/$base"
        cp "$DIR2/$base" "$MERGED/$base"
    fi
done