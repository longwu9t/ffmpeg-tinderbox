#!/bin/bash

SORD_REPO="https://github.com/drobilla/sord.git"
SORD_COMMIT="b9818bc8381dc34cb8b1a293e460d37645a3d3b1"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SORD_REPO" "$SORD_COMMIT" sord
    cd sord

    mkdir build && cd build

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --buildtype=release
        --default-library=static
        -D{docs,tests,tools}"=disabled"
    )

    if [[ $TARGET == win* ]]; then
        myconf+=(
            --cross-file=/cross.meson
        )
    else
        echo "Unknown target"
        return -1
    fi

    meson "${myconf[@]}" ..
    ninja -j"$(nproc)"
    ninja install
}
