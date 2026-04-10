#!/bin/bash
#
# build-xcframework.sh — Build ResearchKit.xcframework from upstream source
#
# Usage:
#   ./build-xcframework.sh [VERSION]
#
# Examples:
#   ./build-xcframework.sh 3.2.0     # Build specific version
#   ./build-xcframework.sh           # Build latest tag
#
# After building, commit and tag:
#   git add Binary/ Package.swift
#   git commit -m "Update ResearchKit.xcframework to VERSION"
#   git tag VERSION
#   git push origin main --tags

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
UPSTREAM_URL="https://github.com/ResearchKit/ResearchKit.git"
WORK_DIR=$(mktemp -d)
VERSION="${1:-}"

echo "=== ResearchKit XCFramework Builder ==="

# Clone upstream
echo "Cloning ResearchKit..."
if [ -n "$VERSION" ]; then
    git clone --depth 1 --branch "$VERSION" "$UPSTREAM_URL" "$WORK_DIR/ResearchKit"
else
    git clone --depth 1 "$UPSTREAM_URL" "$WORK_DIR/ResearchKit"
    VERSION=$(cd "$WORK_DIR/ResearchKit" && git describe --tags --abbrev=0 2>/dev/null || echo "latest")
fi
echo "Building version: $VERSION"

PROJECT="$WORK_DIR/ResearchKit/ResearchKit.xcodeproj"

# Build for iOS device (arm64)
echo "Building for iOS device..."
xcodebuild archive \
    -project "$PROJECT" \
    -scheme ResearchKit \
    -destination 'generic/platform=iOS' \
    -archivePath "$WORK_DIR/ResearchKit-ios" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    -quiet

# Build for iOS Simulator (arm64 + x86_64)
echo "Building for iOS Simulator..."
xcodebuild archive \
    -project "$PROJECT" \
    -scheme ResearchKit \
    -destination 'generic/platform=iOS Simulator' \
    -archivePath "$WORK_DIR/ResearchKit-sim" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    -quiet

# Create XCFramework
echo "Creating XCFramework..."
rm -rf "$SCRIPT_DIR/Binary/ResearchKit.xcframework"
mkdir -p "$SCRIPT_DIR/Binary"

xcodebuild -create-xcframework \
    -framework "$WORK_DIR/ResearchKit-ios.xcarchive/Products/Library/Frameworks/ResearchKit.framework" \
    -framework "$WORK_DIR/ResearchKit-sim.xcarchive/Products/Library/Frameworks/ResearchKit.framework" \
    -output "$SCRIPT_DIR/Binary/ResearchKit.xcframework"

# Cleanup
rm -rf "$WORK_DIR"

echo ""
echo "=== Done ==="
echo "ResearchKit.xcframework built at: Binary/ResearchKit.xcframework"
echo ""
echo "Next steps:"
echo "  git add Binary/ Package.swift"
echo "  git commit -m \"Update ResearchKit.xcframework to $VERSION\""
echo "  git tag $VERSION"
echo "  git push origin main --tags"
