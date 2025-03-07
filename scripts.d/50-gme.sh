#!/bin/bash

GME_REPO="https://bitbucket.org/mpyne/game-music-emu.git"
GME_COMMIT="6cd4bdb69be304f58c9253fb08b8362f541b3b4b"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git clone --branch=master --single-branch "$GME_REPO" gme
    cd gme
    git checkout "$GME_COMMIT"

    mkdir build && cd build

    cmake \
        -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" \
        -DBUILD_SHARED_LIBS=OFF \
        -DENABLE_UBSAN=OFF \
        -GNinja \
        ..
    ninja -j$(nproc)
    ninja install
}

ffbuild_configure() {
    echo --enable-libgme
}

ffbuild_unconfigure() {
    echo --disable-libgme
}
