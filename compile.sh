#!/bin/bash

# Fail on errors
set -e

ASEPRITE_VERSION=v1.3.18.6

SKIA_DIR=/dependencies/skia-m124
SKIA_LIBRARY_DIR="${SKIA_DIR}/out/Release-x64"


echo "Preparing precompiled Skia"

if [ ! -f "${SKIA_LIBRARY_DIR}/libskia.a" ]; then
    echo "Downloading precompiled Skia"

    mkdir -p "${SKIA_DIR}"

    curl -L --fail --retry 3 \
        "https://github.com/aseprite/skia/releases/download/m124-08a5439a6b/Skia-Linux-Release-x64.zip" \
        -o /tmp/skia.zip

    echo "Extracting Skia"

    unzip -q /tmp/skia.zip -d "${SKIA_DIR}"

    rm /tmp/skia.zip
else
    echo "Precompiled Skia already exists, skipping download"
fi

echo "Preparing Aseprite"

cd /output

if [ ! -d "/output/aseprite" ]
then
  echo "Cloning Aseprite"
  git clone -b "${ASEPRITE_VERSION}" --recursive https://github.com/aseprite/aseprite.git
else
  echo "Updating to latest Aseprite version"
  cd aseprite
  git fetch
  git switch "${ASEPRITE_VERSION}" --detach
  git submodule update --init --recursive
fi

cd /output/aseprite

mkdir -p build
cd build

echo "Compiling Asperite"

export CC=clang
export CXX=clang++

cmake \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
	-DCMAKE_CXX_FLAGS:STRING=-stdlib=libstdc++ \
	-DCMAKE_EXE_LINKER_FLAGS:STRING=-stdlib=libstdc++ \
  -DLAF_BACKEND=skia \
  -DSKIA_DIR="${SKIA_DIR}" \
  -DSKIA_LIBRARY_DIR="${SKIA_LIBRARY_DIR}" \
  -DSKIA_LIBRARY="${SKIA_LIBRARY_DIR}"/libskia.a \
  -G Ninja \
  ..

echo "Compiling Aseprite"
ninja aseprite

echo "Build completed successfully!"
echo "Executable: /output/aseprite/build/bin/aseprite"
