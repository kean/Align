#!/usr/bin/env bash
#
# Generates a static, self-hostable DocC site for the Align package.
#
# Output layout (default OUTPUT_DIR=.build/docs):
#   .build/docs/index.html
#   .build/docs/documentation/...
#   .build/docs/data/, css/, js/, images/, ...
#
# Serve the directory from any static host. For GitHub Pages under a
# project repo, the site is reachable at:
#   https://<user>.github.io/<HOSTING_BASE_PATH>/documentation/align/
#
# Environment overrides:
#   SCHEME             Xcode scheme to build (default: Align)
#   DESTINATION        xcodebuild destination (default: generic/platform=iOS)
#   HOSTING_BASE_PATH  URL path prefix for hosting (default: Align)
#                      Use "" when serving from the domain root.
#   OUTPUT_DIR         Final docs directory (default: .build/docs)
#   DERIVED_DATA       Xcode derived data path (default: .build/docc-derived-data)

set -euo pipefail

SCHEME="${SCHEME:-Align}"
DESTINATION="${DESTINATION:-generic/platform=iOS}"
HOSTING_BASE_PATH="${HOSTING_BASE_PATH-Align}"
OUTPUT_DIR="${OUTPUT_DIR:-.build/docs}"
DERIVED_DATA="${DERIVED_DATA:-.build/docc-derived-data}"

if [ -n "$HOSTING_BASE_PATH" ]; then
    DOCC_FLAGS="--transform-for-static-hosting --hosting-base-path $HOSTING_BASE_PATH"
else
    DOCC_FLAGS="--transform-for-static-hosting"
fi

echo "==> Building DocC archive (scheme: $SCHEME, destination: $DESTINATION)"
xcodebuild docbuild \
    -scheme "$SCHEME" \
    -destination "$DESTINATION" \
    -derivedDataPath "$DERIVED_DATA" \
    OTHER_DOCC_FLAGS="$DOCC_FLAGS"

ARCHIVE=$(find "$DERIVED_DATA" -type d -name "${SCHEME}.doccarchive" | head -n 1)
if [ -z "$ARCHIVE" ]; then
    echo "Error: could not locate ${SCHEME}.doccarchive under $DERIVED_DATA" >&2
    exit 1
fi

echo "==> Extracting static site from $ARCHIVE"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"
cp -R "$ARCHIVE/" "$OUTPUT_DIR/"

echo "==> Done. Self-hostable docs at: $OUTPUT_DIR"
if [ -n "$HOSTING_BASE_PATH" ]; then
    echo "    Entry point: /$HOSTING_BASE_PATH/documentation/align/"
else
    echo "    Entry point: /documentation/align/"
fi
