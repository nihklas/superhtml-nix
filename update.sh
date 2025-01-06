#!/usr/bin/env bash

set -e

hash=$(git ls-remote https://github.com/kristoff-it/superhtml.git HEAD | awk '{ print $1 }')

wget "https://raw.githubusercontent.com/kristoff-it/superhtml/$hash/build.zig.zon" -O "build.zig.zon"

zon2json-lock

echo "$hash" > commit
