#!/bin/bash

# Write all inputs to stdout, but also to the last argument provided.
# Usage: cat_tool.sh foo bar -o /tmp/output_file

OUTPUT=$(echo "$@" | grep -E -o -- "-o [^ ]*" | cut -f2 -d' ')

files="$(find . -type f)"
(
    echo "Environment variables:" &&
    env | grep "^LANG_" | sort &&
    echo &&
    echo "Args:" &&
    for arg in "$@"; do
      echo "$arg";
    done &&
    echo &&
    echo "Files:" &&
    echo "$files"
) | sed -E 's/bazel-out\/[^/]+/bazel-out\/<config>/g' > "$OUTPUT"