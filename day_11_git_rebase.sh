#!/bin/bash
# =============================================================
#  Day 11 - Git Rebase
# =============================================================
#  Rebase re-applies your commits on top of another branch,
#  creating a cleaner, linear history without merge commits.
#
#  merge vs rebase:
#   merge  — preserves full history, adds merge commit (messy)
#   rebase — rewrites history as if you always branched from tip
#
#  Golden Rule: NEVER rebase commits already pushed to a
#  shared/public branch. Only rebase LOCAL or private branches.
# =============================================================

# ── Basic Rebase ──────────────────────────────────────────────
# Scenario: main moved forward while you worked on feature branch
# Before rebase:
#   main:    A--B--C--D
#   feature:       \--E--F

git switch feature/new-api
git rebase main
# After rebase:
#   main:    A--B--C--D
#   feature:           \--E'--F'   (E,F replayed on top of D)

# E' and F' are NEW commits (different hashes, same changes)

# Then merge (fast-forward — clean linear history)
git switch main
git merge feature/new-api             # Fast-forward, no merge commit!
git branch -d feature/new-api

# ── Rebase onto a Specific Branch/Commit ─────────────────────
git rebase origin/main                # Rebase onto remote main
git rebase -i HEAD~3                  # Interactive rebase — last 3 commits
git rebase --onto main develop feature # Rebase feature (based on develop) onto main

# ── Interactive Rebase (git rebase -i) ───────────────────────
# MOST POWERFUL Git feature — lets you edit, reorder, squash commits

git rebase -i HEAD~4                  # Edit last 4 commits
git rebase -i abc1234                 # Edit all commits after abc1234

# Editor opens with list of commits (oldest first):
# pick a1b2c3 feat: add login page
# pick d4e5f6 fix: typo in login
# pick g7h8i9 style: format login CSS
# pick j1k2l3 feat: add logout button

# Commands (replace 'pick' with):
# pick   (p) — keep commit as-is
# reword (r) — keep commit, but edit the message
# edit   (e) — keep commit, stop to amend files
# squash (s) — merge into PREVIOUS commit, combine messages
# fixup  (f) — merge into PREVIOUS commit, discard THIS message
# drop   (d) — DELETE this commit entirely
# reorder— just move lines to reorder commits

# Example: squash 3 commits into 1
# pick a1b2c3 feat: add login page
# fixup d4e5f6 fix: typo in login
# fixup g7h8i9 style: format login CSS
# pick j1k2l3 feat: add logout button

# Example: drop a commit
# pick a1b2c3 feat: add login page
# drop d4e5f6 WIP: debugging (remove this!)
# pick g7h8i9 style: format login CSS

# ── Handling Rebase Conflicts ─────────────────────────────────
git rebase main
# CONFLICT in app.py
# Resolve the conflict in the file, then:
git add app.py                         # Mark conflict as resolved
git rebase --continue                  # Continue replaying commits

# Skip the conflicting commit
git rebase --skip

# Abort rebase (go back to before rebase started)
git rebase --abort

# ── Pull with Rebase (Best Practice) ─────────────────────────
git pull --rebase origin main
# Equivalent to: git fetch origin main && git rebase origin/main

# Set as default for all pulls
git config --global pull.rebase true

# ── Cleaning Up Before a PR (Squash Workflow) ─────────────────
# You have 5 messy WIP commits. Clean them before PR:
git log --oneline
# abc1 WIP
# def2 more WIP
# ghi3 testing
# jkl4 fix typo
# mno5 DONE - feature complete

git rebase -i HEAD~5
# Squash all into one:
# pick abc1 WIP
# fixup def2 more WIP
# fixup ghi3 testing
# fixup jkl4 fix typo
# reword mno5 DONE - feature complete  ← gives you a chance to write good message

# After rebase, push (force needed since history changed)
git push --force-with-lease origin feature/my-feature
