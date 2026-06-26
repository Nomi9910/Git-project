#!/bin/bash
# =============================================================
#  Day 2 - Creating & Initializing a Git Repository
# =============================================================
#  A Git repository (repo) is a directory that Git tracks.
#  It contains your project files + a hidden .git/ folder that
#  stores the entire version history, config, and metadata.
#
#  Two ways to get a repo:
#   1. git init   — start a brand new local repo from scratch
#   2. git clone  — download an existing repo from GitHub/remote
# =============================================================

# ── Method 1: Initialize a New Local Repo ────────────────────

# Create a project directory and initialize git
mkdir ~/my-project
cd ~/my-project
git init
# Output: Initialized empty Git repository in ~/my-project/.git/

# What's inside .git/?
ls -la .git/
# branches/    config    description    HEAD
# hooks/       info/     objects/       refs/

cat .git/HEAD          # Points to current branch: ref: refs/heads/main
cat .git/config        # Repo-local config

# Initialize with an explicit branch name (modern approach)
git init -b main

# Initialize in a specific path (creates dir if needed)
git init /opt/myapp

# ── Method 2: Clone an Existing Repository ───────────────────

# Clone from GitHub via HTTPS
git clone https://github.com/username/repo-name.git

# Clone into a custom directory name
git clone https://github.com/username/repo-name.git my-custom-name

# Clone via SSH (requires SSH key setup — see Day 5)
git clone git@github.com:username/repo-name.git

# Clone a specific branch only
git clone -b develop https://github.com/username/repo-name.git

# Shallow clone (last 1 commit only — faster for large repos)
git clone --depth 1 https://github.com/username/repo-name.git

# Clone without checking out files (bare clone — used for servers)
git clone --bare https://github.com/username/repo-name.git

# ── Understanding the .git Directory ─────────────────────────
# .git/config        — repo-specific git config
# .git/HEAD          — pointer to current branch
# .git/objects/      — all your file content (commits, trees, blobs)
# .git/refs/         — branch and tag pointers
# .git/hooks/        — scripts that run on git events (pre-commit, etc.)
# .git/index         — the staging area (index)
# .git/COMMIT_EDITMSG — last commit message

# ── Setting Remote URL After init ────────────────────────────
# If you used git init, connect it to a GitHub repo:
cd ~/my-project
git remote add origin https://github.com/Nomi9910/my-project.git
git remote -v                              # Verify remote was added
# origin  https://github.com/... (fetch)
# origin  https://github.com/... (push)

# Change remote URL
git remote set-url origin https://github.com/Nomi9910/new-name.git

# Remove a remote
git remote remove origin

# ── Checking Repository Status ────────────────────────────────
git status                                 # Most important command!
git status -s                              # Short/compact status output

# Status symbols:
# ?? = untracked (new file, git doesn't know about it)
# A  = added to staging (ready to commit)
# M  = modified
# D  = deleted
# R  = renamed
