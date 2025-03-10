#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "Invalid Arguments"
    exit -1
fi

TARGET="$1"
VARIANT="$2"
shift 2

if ! [[ -f "variants/${TARGET}-${VARIANT}.sh" ]]; then
    echo "Invalid target/variant"
    exit -1
fi

ADDINS=()
ADDINS_STR=""
while [[ "$#" -gt 0 ]]; do
    if ! [[ -f "addins/${1}.sh" ]]; then
        echo "Invalid addin: $1"
        exit -1
    fi

    ADDINS+=( "$1" )
    ADDINS_STR="${ADDINS_STR}${ADDINS_STR:+-}$1"

    shift
done

OWNER="${GITHUB_ACTOR:-nanake}"
OWNER="${OWNER,,}"
REGISTRY="ghcr.io"
TARGET_IMAGE="${REGISTRY}/${OWNER}/base-${TARGET}:latest"
IMAGE="${REGISTRY}/${OWNER}/${TARGET}-${VARIANT}${ADDINS_STR:+-}${ADDINS_STR}:latest"

ffbuild_dockerstage() {
    to_df "RUN --mount=src=${SELF},dst=/stage.sh run_stage /stage.sh"
}

ffbuild_dockerlayer() {
    to_df "COPY --from=${SELFLAYER} \$FFBUILD_PREFIX/. \$FFBUILD_PREFIX"
}

ffbuild_dockerfinal() {
    to_df "COPY --from=${PREVLAYER} \$FFBUILD_PREFIX/. \$FFBUILD_PREFIX"
}

ffbuild_configure() {
    return 0
}

ffbuild_unconfigure() {
    return 0
}

ffbuild_cflags() {
    return 0
}

ffbuild_uncflags() {
    return 0
}

ffbuild_cxxflags() {
    return 0
}

ffbuild_uncxxflags() {
    return 0
}

ffbuild_ldflags() {
    return 0
}

ffbuild_unldflags() {
    return 0
}

ffbuild_libs() {
    return 0
}

ffbuild_unlibs() {
    return 0
}
