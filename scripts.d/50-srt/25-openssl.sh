#!/bin/bash

OPENSSL_REPO="https://github.com/openssl/openssl.git"
OPENSSL_COMMIT="openssl-3.1.0-beta1"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$OPENSSL_REPO" "$OPENSSL_COMMIT" openssl
    cd openssl

    local myconf=(
        threads
        zlib
        no-{shared,tests}
        enable-{camellia,ec,srp}
        --prefix="$FFBUILD_PREFIX"
    )

    if [[ $TARGET == win64 ]]; then
        myconf+=(
            # (win64) install libraries onto lib not lib64
            # otherwise srt fails to find libcrypto
            # see https://github.com/openssl/openssl/issues/16244
            --libdir=lib
            --cross-compile-prefix="$FFBUILD_CROSS_PREFIX"
            mingw64
        )
    elif [[ $TARGET == win32 ]]; then
        myconf+=(
            --cross-compile-prefix="$FFBUILD_CROSS_PREFIX"
            mingw
        )
    else
        echo "Unknown target"
        return -1
    fi

    ./Configure "${myconf[@]}"

    make -j$(nproc)
    make install_sw
}
