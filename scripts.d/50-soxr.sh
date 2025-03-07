#!/bin/bash

# https://sourceforge.net/p/soxr/code/ci/master/tree/
SOXR_SRC="https://github.com/nanake/libsoxr/releases/download/0.1.3/libsoxr-0.1.3-1-mingw-w64.tar.xz"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    curl -L "$SOXR_SRC" | tar xJ
    cd libsoxr*

    if [[ $TARGET == win64 ]]; then
        cd x86_64*
    elif [[ $TARGET == win32 ]]; then
        cd i686*
    else
        echo "Unknown target"
        return -1
    fi

    cp -r include/. "$FFBUILD_PREFIX"/include/.
    cp -r lib/. "$FFBUILD_PREFIX"/lib/.
}

ffbuild_configure() {
    echo --enable-libsoxr
}

ffbuild_unconfigure() {
    echo --disable-libsoxr
}

ffbuild_ldflags() {
    echo -pthread
}

ffbuild_libs() {
    echo -lgomp
}
