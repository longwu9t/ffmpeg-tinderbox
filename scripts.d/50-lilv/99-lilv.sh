#!/bin/bash

LILV_REPO="https://github.com/lv2/lilv.git"
LILV_COMMIT="3a9b8e38a146dfdbb618d95f6db8fa919fa2e3e6"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$LILV_REPO" "$LILV_COMMIT" lilv
    cd lilv

    mkdir build && cd build

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --buildtype=release
        --default-library=static
        -D{bindings_py,docs,tests,tools}"=disabled"
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

ffbuild_configure() {
    echo --enable-lv2
}

ffbuild_unconfigure() {
    echo --disable-lv2
}
