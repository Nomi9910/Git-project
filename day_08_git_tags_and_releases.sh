#!/bin/bash
# =============================================================
#  Day 8 - Git Tags & GitHub Releases
# =============================================================
#  Tags mark specific points in history as important — typically
#  used for version releases (v1.0.0, v2.1.3).
#
#  Two types of tags:
#   - Lightweight: just a pointer to a commit (like a branch)
#   - Annotated:   full object with message, date, tagger (RECOMMENDED)
#
#  Semantic Versioning (SemVer): MAJOR.MINOR.PATCH
#   v1.2.3 → 1=breaking change, 2=new feature, 3=bug fix
# =============================================================

# ── Creating Tags ─────────────────────────────────────────────
# Annotated tag (recommended — includes metadata)
git tag -a v1.0.0 -m "Release version 1.0.0 - Initial release"
git tag -a v1.1.0 -m "Release v1.1.0 - Add login feature"
git tag -a v1.1.1 -m "Release v1.1.1 - Fix login redirect bug"

# Lightweight tag (just a name, no metadata)
git tag v1.0.0-lw

# Tag a specific past commit (not the latest)
git log --oneline                          # Find the commit hash
git tag -a v0.9.0 abc1234 -m "Beta release"

# ── Viewing Tags ──────────────────────────────────────────────
git tag                                    # List all tags
git tag -l                                 # Same as above
git tag -l "v1.*"                          # Filter tags by pattern
git tag -n                                 # List with first line of message
git show v1.0.0                            # Show tag details + commit info
git log --oneline --decorate               # See tags in log

# ── Pushing Tags to GitHub ────────────────────────────────────
git push origin v1.0.0                     # Push a specific tag
git push origin --tags                     # Push ALL tags
git push --follow-tags                     # Push commits + all annotated tags

# ── Deleting Tags ─────────────────────────────────────────────
git tag -d v0.9.0                          # Delete local tag
git push origin --delete v0.9.0            # Delete remote tag
git push origin :refs/tags/v0.9.0          # Alternative delete syntax

# ── Checking Out a Tag ────────────────────────────────────────
git checkout v1.0.0
# WARNING: This puts you in "detached HEAD" state
# You can look around but shouldn't commit here

# Create a branch from a tag (to make changes)
git checkout -b hotfix/v1.0.1 v1.0.0

# ── GitHub Releases ───────────────────────────────────────────
# GitHub Releases are built on top of git tags — they add:
# - Release notes (changelog)
# - Binary file attachments (.tar.gz, .zip, installers)
# - Pre-release flag
# - Auto-generated changelog from PRs/commits

# Create a GitHub Release via CLI (gh):
gh release create v1.0.0 \
  --title "Version 1.0.0 - Initial Release" \
  --notes "## What's New
- Added login page
- Added user authentication
- Added dashboard

## Bug Fixes
- Fixed session timeout issue

## Breaking Changes
- None"

# Create release with files attached
gh release create v1.0.0 \
  --title "v1.0.0" \
  --notes "Initial release" \
  ./dist/myapp-linux-amd64 \
  ./dist/myapp-linux-arm64

# List releases
gh release list

# View a release
gh release view v1.0.0

# Download release assets
gh release download v1.0.0

# Create a pre-release (beta/RC)
gh release create v2.0.0-beta.1 \
  --title "v2.0.0 Beta 1" \
  --notes "Beta release for testing" \
  --prerelease

# Delete a release (tag remains)
gh release delete v0.9.0 --yes

# ── Tagging Best Practices ────────────────────────────────────
# ALWAYS use annotated tags for releases: git tag -a
# Follow SemVer: MAJOR.MINOR.PATCH
# Tag on main/release branch only (never on feature branches)
# Write meaningful tag messages — they appear on GitHub
# Push tags AFTER pushing commits: git push && git push --tags
