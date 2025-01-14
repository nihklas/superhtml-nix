#!/usr/bin/env bash

set -e

hash=$(git ls-remote https://github.com/llogick/zigscient.git HEAD | awk '{ print $1 }')

wget "https://raw.githubusercontent.com/llogick/zigscient/$hash/build.zig.zon" -O "build.zig.zon"

zon2json-lock

sed -i "s/commit = \"[a-z0-9]*\"/commit = \"${hash}\"/" ./flake.nix

