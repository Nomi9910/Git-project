#!/bin/bash
# =============================================================
#  Day 6 - Remote Repositories: Push, Pull & Fetch
# =============================================================
#  A remote is a version of your repo hosted on a server (GitHub).
#  'origin' is the conventional name for your primary remote.
#
#  Key commands:
#   git push   — send your local commits to remote
#   git pull   — fetch + merge remote changes into local
#   git fetch  — download remote changes WITHOUT merging
# =============================================================

# ── Managing Remotes ──────────────────────────────────────────
git remote -v                              # List remotes with URLs
git remote show origin                     # Detailed remote info
git remote add origin git@github.com:Nomi9910/my-project.git
git remote add upstream git@github.com:original-author/repo.git
git remote rename origin old-origin       # Rename a remote
git remote remove upstream                 # Remove a remote
git remote set-url origin git@github.com:Nomi9910/new-repo.git

# ── git push — Send Changes to Remote ────────────────────────
git push                                   # Push current branch to tracked remote
git push origin main                       # Push main branch to origin
git push origin feature/login              # Push a feature branch
git push -u origin main                    # Push AND set upstream tracking (-u)
git push --all origin                      # Push ALL local branches
git push --tags                            # Push all local tags
git push origin v1.0.0                     # Push a specific tag

# Force push (DANGEROUS — rewrites remote history)
git push --force origin main               # Overwrites remote (use with caution!)
git push --force-with-lease origin main    # Safer: fails if remote has new commits

# Delete a remote branch
git push origin --delete feature/old-branch
git push origin :feature/old-branch       # Alternative syntax

# ── git fetch — Download Without Merging ─────────────────────
git fetch                                  # Fetch from default remote (origin)
git fetch origin                           # Fetch all branches from origin
git fetch origin main                      # Fetch specific branch
git fetch --all                            # Fetch from ALL remotes
git fetch --prune                          # Remove deleted remote branch refs

# After fetch, compare without merging:
git log HEAD..origin/main --oneline        # What's on remote but not local
git diff HEAD origin/main                  # Diff between local and remote

# ── git pull — Fetch + Merge ──────────────────────────────────
git pull                                   # Pull from tracked upstream
git pull origin main                       # Pull specific branch from origin

# Pull with rebase (cleaner linear history — recommended)
git pull --rebase                          # Rebase local commits on top of remote
git pull --rebase origin main

# Set rebase as default pull strategy
git config --global pull.rebase true

# ── Tracking Branches ─────────────────────────────────────────
# When you push with -u, local branch tracks the remote branch
git push -u origin main                    # Set upstream for main
git push -u origin feature/login           # Set upstream for feature branch
git branch -vv                             # Show tracking info for all branches
git branch --set-upstream-to=origin/main main  # Set tracking manually

# ── Typical Daily Workflow ────────────────────────────────────
# Morning: get latest changes
git fetch origin
git status                                 # See if you're behind
git pull --rebase origin main              # Update local main

# Work on a feature
git switch -c feature/new-api
echo "# New API" > api.md
git add api.md
git commit -m "feat: add new API documentation"

# Push feature branch
git push -u origin feature/new-api

# Keep feature branch up to date with main
git fetch origin
git rebase origin/main                     # Rebase your branch on latest main

# ── Forking Workflow (Open Source) ────────────────────────────
# Fork a repo on GitHub → clone your fork → add upstream

git clone git@github.com:Nomi9910/forked-repo.git
cd forked-repo
git remote add upstream git@github.com:original/repo.git

# Sync your fork with upstream
git fetch upstream
git switch main
git merge upstream/main
git push origin main
