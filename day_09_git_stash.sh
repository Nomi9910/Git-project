#!/bin/bash
# =============================================================
#  Day 9 - Git Stash
# =============================================================
#  git stash temporarily saves your uncommitted changes so you
#  can switch context (fix a bug, review a PR) without losing
#  your work-in-progress — and without making a commit.
#
#  Think of stash as a clipboard for unfinished changes.
#  Stash is stored as a stack — Last In, First Out (LIFO).
# =============================================================

# ── Basic Stash Operations ────────────────────────────────────
# Scenario: you're mid-feature but need to switch to a hotfix
echo "half-finished feature" >> app.py

git status                             # Modified: app.py
git stash                              # Stash changes (saves and reverts)
git status                             # Working directory is clean now

# Switch context, do your hotfix, come back...
git switch -c hotfix/critical-bug
echo "fix" >> bug.py
git add bug.py && git commit -m "hotfix: fix critical bug"
git switch main
git merge hotfix/critical-bug
git branch -d hotfix/critical-bug

# Restore your stashed work
git stash pop                          # Apply AND remove from stash stack
# OR
git stash apply                        # Apply but KEEP in stash

# ── Named Stashes ─────────────────────────────────────────────
git stash push -m "WIP: user login feature"
git stash push -m "WIP: payment integration"
git stash push -m "WIP: dashboard charts"

# ── Listing Stashes ───────────────────────────────────────────
git stash list
# stash@{0}: On main: WIP: dashboard charts    ← most recent
# stash@{1}: On main: WIP: payment integration
# stash@{2}: On main: WIP: user login feature

git stash show                         # Summary of most recent stash
git stash show stash@{1}               # Summary of specific stash
git stash show -p                      # Full diff of most recent stash
git stash show -p stash@{2}            # Full diff of specific stash

# ── Applying Specific Stashes ─────────────────────────────────
git stash apply stash@{2}              # Apply specific stash (keep in list)
git stash pop stash@{1}                # Apply AND remove specific stash

# ── Stashing Untracked & Ignored Files ───────────────────────
git stash                              # Only stashes tracked modified files
git stash -u                           # Also stash UNTRACKED new files
git stash --include-untracked          # Same as -u
git stash -a                           # Stash everything including .gitignored

# ── Stash on a Specific Branch ────────────────────────────────
# Create a new branch from a stash (very useful!)
git stash branch feature/login stash@{0}
# Creates branch, switches to it, applies stash, removes stash

# ── Cleaning Up Stashes ───────────────────────────────────────
git stash drop                         # Remove most recent stash
git stash drop stash@{1}               # Remove specific stash
git stash clear                        # Remove ALL stashes (irreversible!)

# ── Partial Stash (Interactive) ───────────────────────────────
git stash push -p                      # Interactively choose which changes to stash
# y = stash this hunk
# n = don't stash this hunk
# s = split into smaller hunks
# q = quit

# ── Stash Specific Files ──────────────────────────────────────
git stash push -m "only login files" -- login.html style.css
git stash push -- app.py               # Stash only app.py

# ── Practical Stash Scenarios ─────────────────────────────────

# Scenario 1: Oops, wrong branch
# You committed on main but meant to commit on feature branch
git switch main
echo "new feature code" >> app.py
git add app.py
# Wait — this should be on feature branch!
git stash
git switch -c feature/new-code
git stash pop
git add app.py && git commit -m "feat: new feature code"

# Scenario 2: Pull without losing changes
echo "my changes" >> config.py
git stash
git pull origin main
git stash pop                          # May have conflicts to resolve

# Scenario 3: Quick experiment
git stash                              # Save current work
# Try something experimental...
echo "risky experiment" >> app.py
# If it doesn't work:
git checkout -- app.py                 # Discard experiment
git stash pop                          # Restore your real work
