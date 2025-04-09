#!/usr/bin/env bash

if [ -d build ]; then
    echo "Cleaning build directory"
    rm -rf build
fi

mkdir -p build | exit 1
pushd build
cmake ..
make
res=$?
popd

if [ ${res} -eq 0 ]; then
    echo "
|====================|
|   Build complete   |
|====================|
"
else
    echo "
|====================|
|    Build failed    |
|====================|
"
fi
