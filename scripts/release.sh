#!/usr/bin/env bash
set -euo pipefail

# Release script for heygen-stack
# Usage: ./scripts/release.sh [patch|minor|major]
# Default: patch

BUMP_TYPE="${1:-patch}"
CURRENT=$(cat VERSION)
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"

case "$BUMP_TYPE" in
  patch) PATCH=$((PATCH + 1)) ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  *) echo "Usage: $0 [patch|minor|major]"; exit 1 ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
TAG="v$NEW_VERSION"

echo "Bumping $CURRENT → $NEW_VERSION"

# Update VERSION file
echo "$NEW_VERSION" > VERSION

# Commit and tag
git add VERSION
git commit -m "bump: version $CURRENT → $NEW_VERSION"
git tag -a "$TAG" -m "Release $TAG"

echo ""
echo "Version bumped to $NEW_VERSION"
echo "Tag $TAG created locally"
echo ""
echo "Next steps:"
echo "  git push origin main --follow-tags"
echo ""
echo "This will trigger the GitHub Action to:"
echo "  1. Create a GitHub Release"
echo "  2. Publish to ClawHub (if CLAWHUB_TOKEN secret is set)"
