#!/bin/bash

LIBPNG_REPO="https://github.com/glennrp/libpng.git"
LIBPNG_COMMIT="cd0ea2a7f53b603d3d9b5b891c779c430047b39a"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$LIBPNG_REPO" "$LIBPNG_COMMIT" libpng
    cd libpng

    autoreconf -i

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --with-pic
    )

    if [[ $TARGET == win* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    export CPPFLAGS="$CPPFLAGS -I$FFBUILD_PREFIX/include"

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}
