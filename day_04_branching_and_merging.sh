#!/bin/bash
# =============================================================
#  Day 4 - Branching & Merging
# =============================================================
#  Branches let you work on features, fixes, or experiments
#  in isolation without affecting the main codebase.
#  Think of branches as parallel universes of your codebase.
#
#  Common branch strategy:
#   main     — stable production code
#   develop  — integration branch
#   feature/ — new features
#   hotfix/  — urgent production fixes
#   release/ — release preparation
# =============================================================

# ── Creating & Switching Branches ────────────────────────────
git branch                             # List local branches (* = current)
git branch -a                          # List local AND remote branches
git branch -r                          # List remote branches only
git branch -v                          # List branches with last commit

# Create a new branch
git branch feature/user-login          # Create (stay on current branch)

# Switch to a branch
git checkout feature/user-login        # Old way
git switch feature/user-login          # Modern way (Git 2.23+)

# Create AND switch in one step
git checkout -b feature/payment        # Old way
git switch -c feature/payment          # Modern way

# Create branch from specific commit or tag
git checkout -b hotfix/bug-123 main    # From main
git checkout -b hotfix/bug-123 abc1234 # From commit hash
git checkout -b hotfix/bug-123 v1.2.0  # From tag

# Rename a branch
git branch -m old-name new-name        # Rename any branch
git branch -m new-name                 # Rename current branch

# Delete a branch
git branch -d feature/user-login       # Safe delete (merged branches only)
git branch -D feature/abandoned        # Force delete (even if unmerged)

# ── Making Changes on a Branch ────────────────────────────────
git switch -c feature/readme-update
echo "## Installation" >> README.md
git add README.md
git commit -m "feat: add installation section to README"

echo "## Usage" >> README.md
git add README.md
git commit -m "feat: add usage section to README"

git log --oneline                      # See your commits on this branch

# ── Merging Branches ──────────────────────────────────────────
# Switch to the branch you want to merge INTO
git switch main

# Fast-forward merge (no diverged history — clean linear)
git merge feature/readme-update
# Git just moves the main pointer forward — no merge commit

# Merge with a commit (even if fast-forward is possible)
git merge --no-ff feature/readme-update -m "Merge feature/readme-update into main"

# After merge, delete the feature branch
git branch -d feature/readme-update

# ── Handling Merge Conflicts ───────────────────────────────────
# Conflicts happen when two branches modified the same lines

# Example scenario:
git switch -c feature/title
sed -i 's/My Project/Awesome Project/' README.md
git add README.md && git commit -m "change project title"

git switch main
sed -i 's/My Project/Super Project/' README.md
git add README.md && git commit -m "change title on main"

git merge feature/title
# CONFLICT! Git cannot auto-resolve this

# View conflicted files
git status
# both modified: README.md

# Open the file — you'll see conflict markers:
# <<<<<<< HEAD
# Super Project        ← your current branch version
# =======
# Awesome Project      ← incoming branch version
# >>>>>>> feature/title

# Edit the file to keep what you want, then:
vim README.md                          # Resolve manually
git add README.md                      # Mark as resolved
git commit -m "Merge feature/title: keep Awesome Project name"

# Abort a merge (go back to before merge started)
git merge --abort

# ── Viewing Branch Differences ────────────────────────────────
git diff main..feature/payment          # Diff between two branches
git log main..feature/payment --oneline # Commits in feature not in main
git log --oneline --graph --all         # Full visual branch graph
