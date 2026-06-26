#!/bin/bash
# =============================================================
#  Day 10 - Undoing & Reverting Changes
# =============================================================
#  Git gives you powerful tools to undo mistakes at every stage:
#   - Unstaged changes     → git restore
#   - Staged changes       → git restore --staged
#   - Last commit          → git commit --amend
#   - Old commits (safe)   → git revert
#   - Old commits (danger) → git reset
#
#  Rule of thumb:
#   Use revert for commits already pushed to shared branches.
#   Use reset ONLY on commits that haven't been pushed yet.
# =============================================================

# ── Undo Unstaged Changes (Working Directory) ────────────────
# Discard changes to a file (restore to last commit state)
git restore app.py                     # Modern (Git 2.23+)
git checkout -- app.py                 # Old way (still works)

# Discard ALL unstaged changes
git restore .
git checkout -- .

# Restore a deleted file
rm login.html
git restore login.html                 # Bring it back from last commit

# ── Undo Staged Changes (Unstage) ────────────────────────────
git add app.py                         # Oops, staged by mistake
git restore --staged app.py            # Unstage (keep the file changes)
git reset HEAD app.py                  # Old way to unstage

# Unstage everything
git restore --staged .
git reset HEAD .

# ── Amend Last Commit ─────────────────────────────────────────
# Fix typo in last commit message
git commit --amend -m "Correct commit message here"

# Add a forgotten file to last commit
git add forgotten_file.py
git commit --amend --no-edit           # Keep same message, add the file

# NOTE: --amend rewrites history. Only do this BEFORE pushing!
# If already pushed: git push --force (dangerous on shared branches)

# ── git revert — Safe Undo (Creates a New Commit) ────────────
# Use this for commits already pushed to shared branches
git log --oneline
# abc1234 bad commit that broke production
# def5678 good commit

git revert abc1234                     # Creates new commit that undoes abc1234
git revert HEAD                        # Revert the most recent commit
git revert HEAD~1                      # Revert the commit before HEAD
git revert HEAD~3..HEAD                # Revert last 3 commits

# Revert without opening editor (-n = no commit, stage only)
git revert -n abc1234
git commit -m "Revert: undo broken login feature"

# Revert a merge commit
git revert -m 1 abc1234               # -m 1 = keep the first parent

# ── git reset — Rewrite History (Use Carefully!) ──────────────
git log --oneline
# abc1234 commit3 ← HEAD
# def5678 commit2
# ghi9012 commit1

# --soft: moves HEAD back, keeps changes STAGED
git reset --soft HEAD~1                # Undo last commit, keep staged
git reset --soft abc1234               # Reset to specific commit

# --mixed: moves HEAD back, keeps changes UNSTAGED (DEFAULT)
git reset HEAD~1                       # Undo last commit, keep files
git reset --mixed HEAD~2               # Go back 2 commits, keep changes

# --hard: moves HEAD back, DISCARDS ALL CHANGES (DANGEROUS!)
git reset --hard HEAD~1                # Permanently delete last commit
git reset --hard origin/main           # Reset to match remote exactly
# WARNING: --hard loses uncommitted work forever!

# ── Recover a Lost Commit (git reflog) ───────────────────────
# Even after reset --hard, commits aren't immediately gone!
git reflog                             # Shows all HEAD movements
# HEAD@{0}: reset: moving to HEAD~3
# HEAD@{1}: commit: feat: add payment page   ← your lost commit!
# HEAD@{2}: commit: fix: login bug

git reset --hard HEAD@{1}             # Recover the lost commit!
git checkout -b recovery HEAD@{1}     # Or create a branch at that point

# ── git clean — Remove Untracked Files ───────────────────────
git clean -n                           # Dry run — show what WOULD be deleted
git clean -f                           # Force delete untracked files
git clean -fd                          # Delete untracked files AND directories
git clean -fX                          # Delete only .gitignored files
git clean -fdx                         # Delete untracked + ignored files

# ── Quick Reference: Which tool to use? ──────────────────────
# Unstaged file changes     → git restore <file>
# Staged changes            → git restore --staged <file>
# Undo last commit (local)  → git reset --soft HEAD~1
# Undo pushed commit        → git revert <hash>
# Fix last commit message   → git commit --amend
# Add file to last commit   → git add file + git commit --amend
# Remove untracked files    → git clean -fd
# Recover lost commits      → git reflog
