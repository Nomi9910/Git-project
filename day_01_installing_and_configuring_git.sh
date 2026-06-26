#!/bin/bash
# =============================================================
#  Day 1 - Installing & Configuring Git on RHEL 9
# =============================================================
#  Git is a distributed version control system (VCS) that tracks
#  changes to files over time. It allows multiple developers to
#  collaborate on projects, revert to previous states, and manage
#  code history. Git is the industry standard for source control.
#
#  In this lesson we install Git, verify the installation, and
#  set up the global identity that Git uses to sign every commit.
# =============================================================

# ── Step 1: Install Git via DNF ───────────────────────────────
sudo dnf install -y git

# Verify installation
git --version
# Expected output: git version 2.43.x (or similar)

# Where is git installed?
which git
# /usr/bin/git

# Full package info
rpm -qi git

# ── Step 2: Configure Global Identity ────────────────────────
# This sets WHO you are — Git attaches this to every commit.
# Use your real name and the email linked to your GitHub account.

git config --global user.name  "Your Full Name"
git config --global user.email "you@example.com"

# ── Step 3: Configure Default Editor ─────────────────────────
# Used when writing commit messages, resolving merge conflicts, etc.

git config --global core.editor vim        # Vim (default for most sysadmins)
git config --global core.editor nano       # Nano (beginner-friendly)
git config --global core.editor "code --wait"  # VS Code

# ── Step 4: Configure Default Branch Name ────────────────────
# Modern convention uses 'main' instead of 'master'
git config --global init.defaultBranch main

# ── Step 5: Configure Line Ending Handling ────────────────────
# On Linux: leave line endings as-is
git config --global core.autocrlf input

# ── Step 6: Enable Colorized Output ──────────────────────────
git config --global color.ui auto

# ── Step 7: Configure Credential Helper ──────────────────────
# Cache credentials in memory for 1 hour (3600 seconds)
git config --global credential.helper "cache --timeout=3600"

# Or store permanently (less secure — stored in plain text)
git config --global credential.helper store

# ── Step 8: Verify All Settings ──────────────────────────────
git config --list                          # Show all config values
git config --list --show-origin            # Show where each value comes from
git config user.name                       # Check a specific value
git config user.email

# ── Configuration File Locations ──────────────────────────────
# System-wide  : /etc/gitconfig            (affects all users)
# User-global  : ~/.gitconfig              (affects current user) ← most used
# Repo-local   : .git/config              (overrides for specific repo)

cat ~/.gitconfig                           # View your global config

# ── Step 9: Set up Git Aliases (Optional but useful) ─────────
git config --global alias.st  "status"
git config --global alias.co  "checkout"
git config --global alias.br  "branch"
git config --global alias.lg  "log --oneline --graph --decorate --all"
git config --global alias.last "log -1 HEAD"
git config --global alias.unstage "reset HEAD --"

# Now you can use:
# git st     →  git status
# git co     →  git checkout
# git lg     →  pretty log graph
